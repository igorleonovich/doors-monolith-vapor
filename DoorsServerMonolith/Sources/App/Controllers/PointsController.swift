import Fluent
import Vapor

struct PointsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        // Authentication required
        let points = routes.grouped("points")
        points.group(UserAuthenticator()) { authenticated in
            authenticated.post(use: createHandler)
            authenticated.get(use: getAllHandler)
            authenticated.get(":pointID", use: getHandler)
            authenticated.put(":pointID", use: updateHandler)
            authenticated.delete(":pointID", use: deleteHandler)
//            pointsRoutes.get("search", use: searchHandler)
//            pointsRoutes.get("first", use: firstHandler)
//            pointsRoutes.get("sorted", use: sortedHandler)
        }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Point> {
        let data = try req.content.decode(PointDTO.self)
        let point = Point(userID: data.userID, superPointID: data.superPointID, blockID: data.blockID, index: data.index, text: data.text)
        return point.save(on: req.db).map { point }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Point> {
        return Point.find(req.parameters.get("pointID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Point]> {
        return Point.query(on: req.db).all()
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Point> {
        let updateData = try req.content.decode(PointDTO.self)
        return Point.find(req.parameters.get("pointID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { point in
            point.$user.id = updateData.userID
            point.$superPoint.id = updateData.superPointID
            point.$block.id = updateData.blockID
            point.index = updateData.index
            point.text = updateData.text
            return point.save(on: req.db).map { point }
          }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Point.find(req.parameters.get("pointID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { point in
                point.delete(on: req.db)
                .transform(to: .noContent)
            }
    }

//    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Point]> {
//        guard let searchTerm = req.query[String.self, at: "term"] else {
//            throw Abort(.badRequest)
//        }
//        return Point.query(on: req.db).group(.or) { or in
//            or.filter(\.$text == searchTerm)
//        }
//        .all()
//    }
//
//    func firstHandler(_ req: Request) throws -> EventLoopFuture<Point> {
//        return Point.query(on: req.db)
//            .first()
//            .unwrap(or: Abort(.notFound))
//    }
//
//    func sortedHandler(_ req: Request) throws -> EventLoopFuture<[Point]> {
//        return Point.query(on: req.db)
//          .sort(\.$text, .ascending)
//          .all()
//    }
}

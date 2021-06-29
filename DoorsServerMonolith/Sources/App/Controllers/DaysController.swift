import Fluent
import Vapor

//struct DaysController: RouteCollection {
//
//    func boot(routes: RoutesBuilder) throws {
//        // Authentication required
//        let daysRoutes = routes.grouped("days")
//        daysRoutes.group(UserAuthenticator()) { authenticated in
//            authenticated.post(use: createHandler)
//            authenticated.get(use: getAllHandler)
//            authenticated.get(":dayID", use: getHandler)
//            authenticated.put(":dayID", use: updateHandler)
//            authenticated.delete(":dayID", use: deleteHandler)
//        }
//    }
//
//    func createHandler(_ req: Request) throws -> EventLoopFuture<Day> {
//        let data = try req.content.decode(CreateDayData.self)
//        let newPoint = Point(text: "", userID: data.userID)
//        let pointQuery = newPoint.save(on: req.db).map{newPoint}
//        return pointQuery.flatMap { (point) -> EventLoopFuture<Day> in
//            let newDay = Day(pointID: point.id!, date: data.date, userID: data.userID)
//            let dayQuery = newDay.save(on: req.db).map{newDay}
//            return dayQuery
//        }
//    }
//
//    func getHandler(_ req: Request) throws -> EventLoopFuture<Day> {
//        return Day.find(req.parameters.get("dayID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//    }
//
//    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Day]> {
//        Day.query(on: req.db).all()
//    }
//
//    func updateHandler(_ req: Request) throws -> EventLoopFuture<Day> {
//        let updateData = try req.content.decode(CreateDayData.self)
//        return Day.find(req.parameters.get("dayID"), on: req.db)
//          .unwrap(or: Abort(.notFound))
//          .flatMap { day in
//            day.date = updateData.date
//            return day.save(on: req.db).map { day }
//          }
//    }
//
//    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Day.find(req.parameters.get("dayID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { scene in
//                scene.delete(on: req.db)
//                .transform(to: .noContent)
//            }
//    }
//}
//
//struct CreateDayData: Content {
//    let date: Date
//    let userID: UUID
//}

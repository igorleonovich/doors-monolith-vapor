import Fluent
import Vapor

struct ListsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        // Authentication required
        let list = routes.grouped("lists")
        list.group(UserAuthenticator()) { authenticated in
            authenticated.get("read", use: readHandler)
            authenticated.post("write", use: writeHandler)
        }
    }
    
    func readHandler(_ request: Request) throws -> EventLoopFuture<ListDTO> {
        return try readList(request)
    }
    
    func writeHandler(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try writeList(request)
    }
}

extension ListsController {
    
    // MARK: Reading
    
    func readList(_ req: Request) throws -> EventLoopFuture<ListDTO> {
        return Point.query(on: req.db).all().flatMap { points in
            let pointsDTO = points.map { PointDTO(id: $0.id, userID: $0.$user.id, superPointID: $0.$superPoint.id, blockID: $0.$block.id, index: $0.index, text: $0.text) }
            let listDTO = ListDTO(points: pointsDTO)
            return req.eventLoop.makeSucceededFuture(listDTO)
        }
//        return req.eventLoop.makeSucceededFuture(HTTPStatus.noContent)
    }
    
    
    // MARK: Writing
    
    func writeList(_ req: Request) throws -> EventLoopFuture<HTTPStatus>  {
        // Create / update points
        // Delete points
        let data = try req.content.decode(ListDTO.self)
        return Point.query(on: req.db).all()
          .flatMap { points in
            points.forEach { point in
                if let dataPoint = data.points.first(where: { $0.userID == point.id }) {
                    point.id = dataPoint.id
                    point.$user.id = dataPoint.userID
                    point.$superPoint.id = dataPoint.superPointID
                    point.$block.id = dataPoint.blockID
                    point.index = dataPoint.index
                    point.text = dataPoint.text
                } else {
                    point.delete(on: req.db)
                }
                point.save(on: req.db)
            }
            return req.eventLoop.makeSucceededFuture(HTTPStatus.noContent)
          }
    }
    
//    func writeRootScene(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        let text = "* Scene"
//        let fileName = "../../../data/domains/il/scene-il/scenes/current/current.md"
//        let filePath = req.application.directory.publicDirectory + fileName
//        return req.fileio.writeFile(ByteBuffer(string: text), at: filePath)
//            .transform(to: HTTPStatus.noContent)
//    }
}

//import Fluent
//import Vapor
//
//struct ScenesController: RouteCollection {
//
//    func boot(routes: RoutesBuilder) throws {
//        // Authentication required
//        let scenesRoutes = routes.grouped("scenes")
//        scenesRoutes.group(UserAuthenticator()) { authenticated in
//            authenticated.post(use: createHandler)
//            authenticated.get(use: getAllHandler)
//            authenticated.get(":sceneID", use: getHandler)
//            authenticated.put(":sceneID", use: updateHandler)
//            authenticated.delete(":sceneID", use: deleteHandler)
//        }
//    }
//
//    func createHandler(_ req: Request) throws -> EventLoopFuture<Scene> {
//        let data = try req.content.decode(CreateSceneData.self)
//        let newPoint = Point(text: "", userID: data.userID)
//        let pointQuery = newPoint.save(on: req.db).map{newPoint}
//        return pointQuery.flatMap { (point) -> EventLoopFuture<Scene> in
//            let newScene = Scene(orderedNumber: data.orderedNumber, name: data.name,
//                                   startPointID: data.startPointID, endPointID: data.endPointID, pointID: point.id!, userID: data.userID)
//            let sceneQuery = newScene.save(on: req.db).map{newScene}
//            return sceneQuery
//        }
//    }
//
//    func getHandler(_ req: Request) throws -> EventLoopFuture<Scene> {
//        return Scene.find(req.parameters.get("sceneID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//    }
//
//    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Scene]> {
//        Scene.query(on: req.db).all()
//    }
//
//    func updateHandler(_ req: Request) throws -> EventLoopFuture<Scene> {
//        let updateData = try req.content.decode(CreateSceneData.self)
//        return Scene.find(req.parameters.get("sceneID"), on: req.db)
//          .unwrap(or: Abort(.notFound))
//          .flatMap { scene in
//            scene.name = updateData.name
//            scene.$startPoint.id = updateData.startPointID
//            scene.$endPoint.id = updateData.endPointID
//            scene.$user.id = updateData.userID
//            return scene.save(on: req.db).map { scene }
//          }
//    }
//
//    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Scene.find(req.parameters.get("sceneID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { scene in
//                scene.delete(on: req.db)
//                .transform(to: .noContent)
//            }
//    }
//}
//
//struct CreateSceneData: Content {
//    let superpoint: UUID?
//    let orderedNumber: Int
//    let name: String?
//    let startPointID: UUID?
//    let endPointID: UUID?
//    let userID: UUID
//}

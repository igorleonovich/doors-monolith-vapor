import Fluent
import Vapor

struct LevelsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        // Authentication required
        let levels = routes.grouped("levels")
        levels.group(UserAuthenticator()) { authenticated in
            authenticated.post(use: createHandler)
            authenticated.get(use: getAllHandler)
            authenticated.get(":levelID", use: getHandler)
            authenticated.put(":levelID", use: updateHandler)
            authenticated.delete(":levelID", use: deleteHandler)
        }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Level> {
        let data = try req.content.decode(LevelDTO.self)
        let level = Level(userID: data.userID, index: data.index)
        return level.save(on: req.db).map { level }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Level]> {
        return Level.query(on: req.db).all()
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Level> {
        return Level.find(req.parameters.get("levelID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Level> {
        let updateData = try req.content.decode(LevelDTO.self)
        return Level.find(req.parameters.get("levelID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { level in
            level.$user.id = updateData.userID
            level.index = updateData.index
            return level.save(on: req.db).map { level }
          }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Level.find(req.parameters.get("levelID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { level in
                level.delete(on: req.db)
                .transform(to: .noContent)
            }
    }
}

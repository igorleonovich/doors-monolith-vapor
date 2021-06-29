import Fluent
import Vapor

struct BlocksController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        // Authentication required
        let blocks = routes.grouped("blocks")
        blocks.group(UserAuthenticator()) { authenticated in
            authenticated.post(use: createHandler)
            authenticated.get(use: getAllHandler)
            authenticated.get(":blockID", use: getHandler)
            authenticated.put(":blockID", use: updateHandler)
            authenticated.delete(":blockID", use: deleteHandler)
        }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Block> {
        let data = try req.content.decode(BlockDTO.self)
        let block = Block(userID: data.userID, levelID: data.levelID, blockTypeID: data.blockTypeID, index: data.index)
        return block.save(on: req.db).map { block }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Block]> {
        return Block.query(on: req.db).all()
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Block> {
        return Block.find(req.parameters.get("blockID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Block> {
        let updateData = try req.content.decode(BlockDTO.self)
        return Block.find(req.parameters.get("blockID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { block in
            block.$user.id = updateData.userID
            block.$level.id = updateData.levelID
            block.$blockType.id = updateData.blockTypeID
            block.index = updateData.index
            return block.save(on: req.db).map { block }
          }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Block.find(req.parameters.get("blockID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { block in
                block.delete(on: req.db)
                .transform(to: .noContent)
            }
    }
}

import Fluent
import Vapor

struct BlockTypesController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        // Authentication required
        let blockTypes = routes.grouped("block-types")
        blockTypes.group(UserAuthenticator()) { authenticated in
            authenticated.post(use: createHandler)
            authenticated.get(use: getAllHandler)
            authenticated.get(":blockTypeID", use: getHandler)
            authenticated.put(":blockTypeID", use: updateHandler)
            authenticated.delete(":blockTypeID", use: deleteHandler)
        }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<BlockType> {
        let data = try req.content.decode(BlockTypeDTO.self)
        let blockType = BlockType(userID: data.userID, superBlockTypeID: data.superBlockTypeID, name: data.name, pluralName: data.pluralName)
        return blockType.save(on: req.db).map { blockType }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[BlockType]> {
        return BlockType.query(on: req.db).all()
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<BlockType> {
        return BlockType.find(req.parameters.get("blockTypeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<BlockType> {
        let updateData = try req.content.decode(BlockTypeDTO.self)
        return BlockType.find(req.parameters.get("blockTypeID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { blockType in
            blockType.$user.id = updateData.userID
            blockType.$superBlockType.id = updateData.superBlockTypeID
            blockType.name = updateData.name
            blockType.pluralName = updateData.pluralName
            return blockType.save(on: req.db).map { blockType }
          }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BlockType.find(req.parameters.get("blockTypeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { blockType in
                blockType.delete(on: req.db)
                .transform(to: .noContent)
            }
    }
}

import Fluent

struct CreateBlock: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("blocks")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("levelID", .uuid, .references("levels", "id"))
            .field("blockTypeID", .uuid, .references("block-types", "id"))
            .field("index", .int, .required)
            .field("flipFlag", .bool, .required, .custom("DEFAULT FALSE"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("blocks").delete()
    }
}

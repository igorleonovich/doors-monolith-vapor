import Fluent

struct CreatePoint: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("points")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("superPointID", .uuid, .references("points", "id"))
            .field("blockID", .uuid, .references("blocks", "id"))
            .field("index", .int, .required)
            .field("flipFlag", .bool, .required, .custom("DEFAULT FALSE"))
            .field("text", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("points").delete()
    }
}

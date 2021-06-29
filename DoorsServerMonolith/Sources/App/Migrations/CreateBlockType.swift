import Fluent

struct CreateBlockType: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("block-types")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("superBlockTypeID", .uuid, .references("block-types", "id"))
            .field("name", .string, .required)
            .field("pluralName", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("block-types").delete()
    }
}

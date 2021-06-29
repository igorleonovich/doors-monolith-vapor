import Fluent

struct CreateLevel: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("levels")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("index", .int, .required)
            .field("flipFlag", .bool, .required, .custom("DEFAULT FALSE"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("levels").delete()
    }
}

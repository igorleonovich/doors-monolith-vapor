import Fluent


//struct CreateAccount: Migration {
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        return database.enum("billing_status")
//            .case("current")
//            .case("past_due")
//            .create()
//            .flatMap { billing_status in
//                return database.schema("accounts")
//                    .id()
//                    .field(
//                        "billing_status",
//                        billing_status,
//                        .required,
//                        .custom("DEFAULT 'current'")
//                    )
//                    .create()
//            }
//    }
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema("accounts").delete().flatMap {
//            return database.enum("billing_status").delete()
//        }
//    }
//}


struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("role")
            .case("empty")
            .case("guest")
            .case("use")
            .case("test")
            .case("dev")
            .case("publish")
            .case("admin")
            .create()
            .flatMap { role in
                return database.schema("users")
                    .id()
                    .field("username", .string, .required)
                    .field("email", .string, .required)
                    .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
                    .field("phone", .string)
                    .field("is_phone_verified", .bool, .required, .custom("DEFAULT FALSE"))
                    .field("password_hash", .string, .required)
                    .field("role", role, .required, .custom("DEFAULT 'empty'"))
                    .unique(on: "email")
                    .unique(on: "phone")
                    .unique(on: "username")
                    .field("name", .string)
                    .create()
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}

//
//  CreateMarkupElement.swift
//  
//
//  Created by Igor Leonovich on 26.07.21
//  Copyright © 2021 FT. All rights reserved.
//

import Fluent

struct CreateMarkupElementContainer: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("markup-element-containers")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("markupElementAliasID", .uuid, .references("markup-element-aliases", "id"))
            .field("markupElementID", .uuid, .references("markup-elements", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("markup-element-containers").delete()
    }
}

struct CreateMarkupElementAlias: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("markup-element-aliases")
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("markupElementID", .uuid, .references("markup-elements", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("markup-element-aliases").delete()
    }
}

struct CreateMarkupElement: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("markup_element_types")
            .case("orderedUnordered")
            .case("pointAction")
            .case("date")
            .case("byTime")
            .case("byX")
            .case("level")
            .case("plan")
            .create()
            .flatMap { markupElementType in
                return database.schema("markup-elements")
                    .id()
                    .field("userID", .uuid, .required, .references("users", "id"))
                    .field("markup-element-type", markupElementType, .required, .custom("DEFAULT 'orderedUnordered'"))
                    .create()
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("markup-elements").delete()
    }
}

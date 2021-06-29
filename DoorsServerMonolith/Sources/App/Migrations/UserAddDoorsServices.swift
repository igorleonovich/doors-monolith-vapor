//
//  UserAddDoorsServices.swift
//  
//
//  Created by Igor Leonovich on 23.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import Fluent

struct UserAddDoorsServices: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("doors_service")
            .case("id")
            .case("scene")
            .case("engine")
            .case("bank")
            .case("arteka")
            .create()
            .flatMap { _ in
                return database.schema("users")
                    .field("doors_services_active", .sql(raw: "text[]"), .required, .custom("DEFAULT ARRAY['id']"))
                    .update()
            }
            .flatMap {
                return database.schema("users")
                    .field("doors_services_inactive", .sql(raw: "text[]"), .required, .custom("DEFAULT ARRAY['scene','engine','bank','arteka']"))
                    .update()
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("doors_service").read().flatMap { doorsService in
            return database.schema("users").field("doors_services_active", .sql(raw: "text[]"), .required, .custom("DEFAULT ARRAY['id']")).delete().flatMap {
                    return database.schema("users").field("doors_services_inactive", .sql(raw: "text[]"), .required, .custom("DEFAULT ARRAY['scene']")).delete().flatMap {
                        return database.enum("doors_service").delete()
                    }
                }
        }
    }
}

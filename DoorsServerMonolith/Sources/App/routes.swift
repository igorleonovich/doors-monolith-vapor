import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return req.view.render("doors/base-body-home",  ["pageTitle": "D O O R S"])
    }

    app.get("signup") { req in
        return req.view.render("doors/base-body-sign-up", ["pageTitle": "D O O R S"])
    }

    app.get("login") { req in
        return req.view.render("doors/base-body-log-in", ["pageTitle": "D O O R S"])
    }

    app.get("console") { req in
        return req.view.render("console/base", ["pageTitle": "C O N S O L E"])
    }

//    app.get("scene") { req in
//        return req.view.render("scene/base", ["pageTitle": "S C E N E"])
//    }
    
    try app.group("api") { api in
        // Authentication
        try api.register(collection: AuthenticationController())
        try api.register(collection: UsersController())
        try api.register(collection: DoorsServicesController())
        try api.register(collection: LevelsController())
        try api.register(collection: BlockTypesController())
        try api.register(collection: BlocksController())
        try api.register(collection: PointsController())
        try api.register(collection: ListsController())
    }
}

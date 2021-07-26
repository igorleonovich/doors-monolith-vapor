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

//    app.get("plan") { req in
//        return req.view.render("plan/base", ["pageTitle": "P L A N"])
//    }
    
    try app.group("api") { api in
        // Authentication
        try api.register(collection: AuthenticationController())
        try api.register(collection: UsersController())
        try api.register(collection: DoorsServicesController())
    }
}

import Fluent
import FluentPostgresDriver
import JWT
import Leaf
import LeafKit
import Mailgun
import QueuesRedisDriver
import Vapor

public func configure(_ app: Application) throws {
    
    // MARK: - Leaf
    if !app.environment.isRelease {
        LeafRenderer.Option.caching = .bypass
    }
    
    if app.environment != .testing {
        app.views.use(.leaf)
    }
    
    // MARK: JWT
    if app.environment != .testing {
        let jwksFilePath = app.directory.workingDirectory + (Environment.get("JWKS_KEYPAIR_FILE") ?? "ProtectedResources/keypair.jwks")
         guard
             let jwks = FileManager.default.contents(atPath: jwksFilePath),
             let jwksString = String(data: jwks, encoding: .utf8)
             else {
                 fatalError("Failed to load JWKS Keypair file at: \(jwksFilePath)")
         }
         try app.jwt.signers.use(jwksJSON: jwksString)
    }
    
    // MARK: Database
    // Configure PostgreSQL database
    app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ), as: .psql)
        
    // MARK: Middleware Init
    app.middleware = .init()
    
    // MARK: CORS Middleware
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    app.middleware.use(cors)
    
    // MARK: Error Middleware
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
    // MARK: Route Logging Middleware
    // Only add this if you want to enable the default per-route logging
//    let routeLogging = RouteLoggingMiddleware(logLevel: .info)
//    app.middleware.use(routeLogging)
    
    // MARK: Files Middleware
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // MARK: Model Middleware
    
    // MARK: Mailgun
    app.mailgun.configuration = .environment
    app.mailgun.defaultDomain = .sandbox
    
    // MARK: App Config
    app.config = .environment
    
    // MARK: Routing
    try routes(app)
    
    // MARK: Migrations
    try migrations(app)    
    try queues(app)
    try services(app)
    
    if app.environment == .development {
        try app.autoMigrate().wait()
        try app.queues.startInProcessJobs()
    }
    
    // MARK: Logs
    app.logger.logLevel = .debug
}

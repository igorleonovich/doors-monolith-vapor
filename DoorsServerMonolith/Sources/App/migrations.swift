import Vapor
import FluentSQL

func migrations(_ app: Application) throws {
    // User
    app.migrations.add(CreateUser())
    
    // Auth
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
    
    // Scene
    app.migrations.add(CreateLevel())
    app.migrations.add(CreateBlockType())
    app.migrations.add(CreateBlock())
    app.migrations.add(CreatePoint())
}

import Vapor
import FluentSQL

func migrations(_ app: Application) throws {
    // User
    app.migrations.add(CreateUser())
    
    // Auth
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
    
    // Plan
    app.migrations.add(CreateDataElement())
    app.migrations.add(CreateDataElementAlias())
    app.migrations.add(CreateDataElementContainer())
    
    app.migrations.add(CreateMarkupElement())
    app.migrations.add(CreateMarkupElementAlias())
    app.migrations.add(CreateMarkupElementContainer())
    
    app.migrations.add(CreateElement())
}

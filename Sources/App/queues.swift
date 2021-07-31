import Vapor
import Queues

func queues(_ app: Application) throws {
    // MARK: Queues Configuration
    if app.environment != .testing {
        try app.queues.use(
            .redis(url:
                Environment.get("REDIS_URL") ?? ""
            )
        )
    }
    
    // MARK: Jobs
//    app.queues.add(EmailJob())
}

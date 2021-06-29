import Vapor

struct LevelDTO: Content {
    let userID: UUID
    let index: Int
}

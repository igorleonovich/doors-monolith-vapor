import Vapor

struct PointDTO: Content {
    let id: UUID?
    let userID: UUID
    let superPointID: UUID?
    let blockID: UUID?
    let index: Int
    let text: String
}

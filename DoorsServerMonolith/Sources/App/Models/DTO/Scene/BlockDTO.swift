import Vapor

struct BlockDTO: Content {
    let userID: UUID
    let levelID: UUID
    let blockTypeID: UUID
    let index: Int
}

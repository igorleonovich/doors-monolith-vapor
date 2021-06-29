import Vapor

struct BlockTypeDTO: Content {
    let userID: UUID
    let superBlockTypeID: UUID?
    let name: String
    let pluralName: String
}

import Vapor
import Fluent

final class Block: Model, Content {
  
    static let schema = "blocks"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Parent(key: "levelID")
    var level: Level
    
    @Parent(key: "blockTypeID")
    var blockType: BlockType
    
    @Field(key: "index")
    var index: Int
    
    @Field(key: "flipFlag")
    var flipFlag: Bool
    
    @Children(for: \.$block)
    var points: [Point]

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, levelID: Level.IDValue, blockTypeID: BlockType.IDValue, index: Int) {
        self.id = id
        self.$user.id = userID
        self.$level.id = levelID
        self.$blockType.id = blockTypeID
        self.index = index
        self.flipFlag = false
    }
}

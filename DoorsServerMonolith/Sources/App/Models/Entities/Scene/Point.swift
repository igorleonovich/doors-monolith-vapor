import Vapor
import Fluent

final class Point: Model, Content {
  
    static let schema = "points"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @OptionalParent(key: "superPointID")
    var superPoint: Point?
    
    @OptionalParent(key: "blockID")
    var block: Block?
    
    @Field(key: "index")
    var index: Int
    
    @Field(key: "flipFlag")
    var flipFlag: Bool
    
    @Field(key: "text")
    var text: String

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, superPointID: Point.IDValue? = nil, blockID: Block.IDValue? = nil, index: Int, text: String) {
        self.id = id
        self.$user.id = userID
        self.$superPoint.id = superPointID
        self.$block.id = blockID
        self.index = index
        self.flipFlag = false
        self.text = text
    }
}

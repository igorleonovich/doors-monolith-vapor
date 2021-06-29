import Vapor
import Fluent

final class BlockType: Model, Content {
  
    static let schema = "block-types"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @OptionalParent(key: "superBlockTypeID")
    var superBlockType: BlockType?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "pluralName")
    var pluralName: String

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, superBlockTypeID: Block.IDValue? = nil, name: String, pluralName: String) {
        self.id = id
        self.$user.id = userID
        self.$superBlockType.id = superBlockTypeID
        self.name = name
        self.pluralName = pluralName
    }
}

import Vapor
import Fluent

final class Level: Model, Content {
  
    static let schema = "levels"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Field(key: "index")
    var index: Int
    
    @Field(key: "flipFlag")
    var flipFlag: Bool
    
    @Children(for: \.$level)
    var blocks: [Block]

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, index: Int) {
        self.id = id
        self.$user.id = userID
        self.index = index
        self.flipFlag = false
    }
}

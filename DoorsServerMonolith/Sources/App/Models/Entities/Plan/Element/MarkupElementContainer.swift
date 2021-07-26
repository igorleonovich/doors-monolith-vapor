//
//  MarkupElementContainer.swift
//  
//
//  Created by Igor Leonovich on 26.07.21
//  Copyright © 2021 FT. All rights reserved.
//

import Vapor
import Fluent

final class MarkupElementContainer: Model, Codable {
  
    static let schema = "markup-element-containers"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @OptionalParent(key: "markupElementAlias")
    var markupElementAlias: MarkupElementAlias?
    
    @OptionalParent(key: "markupElement")
    var markupElement: MarkupElement?

    init() {}

    init(id: UUID? = nil, userID: User.IDValue, markupElementAliasID: MarkupElementAlias.IDValue? = nil, markupElementID: MarkupElement.IDValue? = nil) {
        self.id = id
        self.$user.id = userID
        self.$markupElementAlias.id = markupElementAliasID
        self.$markupElement.id = markupElementID
    }
}

final class MarkupElementAlias: Model, Codable {
    
    static let schema = "markup-element-aliases"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Parent(key: "markupElementID")
    var markupElement: MarkupElement
    
    init() {}

    init(id: UUID? = nil, userID: User.IDValue, markupElementID: MarkupElement.IDValue) {
        self.id = id
        self.$user.id = userID
        self.$markupElement.id = markupElementID
    }
}

final class MarkupElement: Model, Codable {
    
    static let schema = "markup-elements"

    @ID
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Field(key: "type")
    var type: MarkupElementType
    
    init() {}

    init(id: UUID? = nil, userID: User.IDValue, type: MarkupElementType) {
        self.id = id
        self.$user.id = userID
        self.type = type
    }
}

public enum MarkupElementType: String, Codable {
    case orderedUnordered, pointAction, date, byTime, byX, level, plan
}

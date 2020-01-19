//
//  ActionDTO.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 9.08.19.
//

import Foundation
import ObjectMapper

@available(iOS 10.0, *)
class ActionDTO: Mappable {
    var id: String!
    var actionType: String!
    var args: [String: Any]!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        actionType <- map["type"]
        args <- map["args"]
    }
    
    func toAction(actionFactory: ActionFactory) -> Action? {
        if id != nil, args != nil {
            if self.actionType == "AttributeExpression",
                let attributeExpression = AttributeExpressionDTO(JSON: args)?.toAttributeExpression() {
                let rerender = args["rerender"] as? Bool ?? false
                return actionFactory.getAttributeExpressionAction(id: id, attributeExpression: attributeExpression, rerender: rerender)
            }
            if self.actionType == "HTTPRequest",
                let urlExpression = args["urlExpression"] as? String {
                return actionFactory.getHTTPRequestAction(id: id, urlExpression: urlExpression, attributeName: args["attributeName"] as? String)
            }
        }
        return nil
    }
}

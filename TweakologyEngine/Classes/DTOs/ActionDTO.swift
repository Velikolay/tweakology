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
    var actionType: String!
    var args: [String: Any]!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        actionType <- map["type"]
        args <- map["args"]
    }
    
    func toAction(actionFactory: ActionFactory) -> Action? {
        if args != nil {
            if self.actionType == "UpdateAttribute",
                let attributeExpression = AttributeExpressionDTO(JSON: args)?.toAttributeExpression() {
                return actionFactory.getUpdateAttributeAction(attributeExpression: attributeExpression)
            }
            if self.actionType == "UpdateAttributeWithRerender",
                let attributeExpression = AttributeExpressionDTO(JSON: args)?.toAttributeExpression() {
                return actionFactory.getUpdateAttributeWithRerenderAction(attributeExpression: attributeExpression)
            }
            if self.actionType == "HTTPRequestAction",
                let urlExpression = args["urlExpression"] as? String {
                return actionFactory.getHTTPRequestAction(urlExpression: urlExpression, attributeName: args["attributeName"] as? String)
            }
        }
        return nil
    }
}

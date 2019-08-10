//
//  AttributeExpressionDTO.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 22.07.19.
//

import Foundation
import ObjectMapper

class AttributeExpressionDTO: Mappable {
    var attributeName: String!
    var expression: String!
    var valueType: String!
    var defaultValue: Any?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        attributeName <- map["attributeName"]
        expression <- map["expression"]
        valueType <- map["valueType"]
        defaultValue <- map["defaultValue"]
    }
    
    func toAttributeExpression() -> AttributeExpression? {
        if
            self.attributeName != nil,
            self.expression != nil,
            self.valueType != nil,
            let valueType = AttributeType(rawValue: self.valueType) {
            return AttributeExpression(attributeName: self.attributeName, expression: self.expression, valueType: valueType, defaultValue: self.defaultValue)
        }
        return nil
    }
}

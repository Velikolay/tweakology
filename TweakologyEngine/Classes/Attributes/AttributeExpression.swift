//
//  AttributeExpression.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.07.19.
//

import Foundation

enum AttributeType: String {
    case string
    case boolean
    case integer
    case float
    case date
}

struct AttributeExpression {
    var attributeName: String
    var expression: String
    var valueType: AttributeType
    var defaultValue: Any

    public init(attributeName: String, expression: String, valueType: AttributeType = AttributeType.string, defaultValue: Any? = nil) {
        self.attributeName = attributeName
        self.expression = expression
        self.valueType = valueType

        if let defaultValue = defaultValue {
            self.defaultValue = defaultValue
        } else {
            self.defaultValue = defaultFrom(type: self.valueType)
        }
    }
}

func defaultFrom(type: AttributeType) -> Any {
    switch type {
    case AttributeType.boolean:
        return false
    case AttributeType.integer:
        return 0
    case AttributeType.float:
        return 0.0
    case AttributeType.string:
        return ""
    case AttributeType.date:
        return Date()
    }
}

func valueFrom(string: String, type: AttributeType) -> Any? {
    switch type {
    case AttributeType.boolean:
        return BooleanLiteralType(string)
    case AttributeType.integer:
        return IntegerLiteralType(string)
    case AttributeType.float:
        return FloatLiteralType(string)
    case AttributeType.string:
        return string
    case AttributeType.date:
        return Date()
    }
}

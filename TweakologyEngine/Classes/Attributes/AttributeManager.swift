//
//  AttriubteManager.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 9.07.19.
//

import Foundation

class AttriubteManager {
    private var contextStore: ContextStore
    private var expressionProcessor: ExpressionProcessor
    
    init(expressionProcessor: ExpressionProcessor, contextStore: ContextStore) {
        self.expressionProcessor = expressionProcessor
        self.contextStore = contextStore
    }
    
    public func get(name: String) -> Any? {
        return self.contextStore.get(key: name)
    }
    
    public func update(expression: AttributeExpression) {
        if self.get(name: expression.attributeName) == nil {
            self.contextStore.set(key: expression.attributeName, value: expression.defaultValue)
        }
        if let strValue = expressionProcessor.process(expression: expression, context: self.contextStore.getAll()), let value = valueFrom(string: strValue, type: expression.valueType) {
            self.contextStore.set(key: expression.attributeName, value: value)
        }
    }
}

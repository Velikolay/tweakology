//
//  UpdateAttributeAction.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 26.07.19.
//

import Foundation

class UpdateAttributeAction: Action {
    internal var contextStore: AttributeStore
    internal var expressionProcessor: ExpressionProcessor
    internal var attributeExpression: AttributeExpression
    
    init(contextStore: AttributeStore, expressionProcessor: ExpressionProcessor, attributeExpression: AttributeExpression) {
        self.expressionProcessor = expressionProcessor
        self.contextStore = contextStore
        self.attributeExpression = attributeExpression
    }
    
    func execute() {
        if self.contextStore.get(key: self.attributeExpression.attributeName) == nil {
            self.contextStore.set(key: self.attributeExpression.attributeName, value: self.attributeExpression.defaultValue)
        }
        if let strValue = expressionProcessor.process(expression: self.attributeExpression.expression, context: self.contextStore.getAll()), let value = valueFrom(string: strValue, type: attributeExpression.valueType) {
            self.contextStore.set(key: self.attributeExpression.attributeName, value: value)
        }
    }
}

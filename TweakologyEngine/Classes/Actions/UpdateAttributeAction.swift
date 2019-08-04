//
//  UpdateAttributeAction.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 26.07.19.
//

import Foundation

class UpdateAttributeAction: Action {
    internal var attributeStore: AttributeStore
    internal var expressionProcessor: ExpressionProcessor
    internal var attributeExpression: AttributeExpression
    
    init(attributeStore: AttributeStore, expressionProcessor: ExpressionProcessor, attributeExpression: AttributeExpression) {
        self.attributeStore = attributeStore
        self.expressionProcessor = expressionProcessor
        self.attributeExpression = attributeExpression
    }
    
    func execute() {
        if self.attributeStore.get(key: self.attributeExpression.attributeName) == nil {
            self.attributeStore.set(key: self.attributeExpression.attributeName, value: self.attributeExpression.defaultValue)
        }
        if let strValue = expressionProcessor.process(expression: self.attributeExpression.expression, context: self.attributeStore.getAll()), let value = valueFrom(string: strValue, type: attributeExpression.valueType) {
            self.attributeStore.set(key: self.attributeExpression.attributeName, value: value)
        }
    }
}

//
//  UpdateAttributeWithRerenderAction.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 26.07.19.
//

import Foundation

@available(iOS 10.0, *)
class AttributeExpressionAction: Action {
    private var id: String
    private var attributeExpression: AttributeExpression
    private var rerender: Bool
    private var attributeStore: AttributeStore
    private var expressionProcessor: ExpressionProcessor
    private var tweakologyLayoutEngine: TweakologyLayoutEngine?
    private var attributeIndexer: AttributeIndexer?

    init(
        id: String,
        attributeExpression: AttributeExpression,
        rerender: Bool = false,
        attributeStore: AttributeStore,
        expressionProcessor: ExpressionProcessor,
        tweakologyLayoutEngine: TweakologyLayoutEngine? = nil,
        attributeIndexer: AttributeIndexer? = nil
    ) {
        self.id = id
        self.attributeExpression = attributeExpression
        self.rerender = rerender
        self.attributeStore = attributeStore
        self.expressionProcessor = expressionProcessor
        self.tweakologyLayoutEngine = tweakologyLayoutEngine
        self.attributeIndexer = attributeIndexer
    }

    func getId() -> String {
        return id
    }

    func execute() {
        if self.attributeStore.get(key: self.attributeExpression.attributeName) == nil {
            self.attributeStore.set(key: self.attributeExpression.attributeName, value: self.attributeExpression.defaultValue)
        }
        if let strValue = expressionProcessor.process(expression: self.attributeExpression.expression, context: self.attributeStore.getAll()), let value = valueFrom(string: strValue, type: attributeExpression.valueType) {
            self.attributeStore.set(key: self.attributeExpression.attributeName, value: value)
        }

        if self.rerender,
            let attributeIndexer = self.attributeIndexer,
            let tweakologyLayoutEngine = self.tweakologyLayoutEngine,
            let changeSeq = attributeIndexer.getIndex()[self.attributeExpression.attributeName]?.map({
                [
                    "operation": "modify",
                    "view": $0
                ]
            })
        {
            tweakologyLayoutEngine.tweak(changeSeq: changeSeq)
        }
    }

    func toDTO() -> ActionDTO {
        return ActionDTO(JSON: [
            "id": id,
            "type": "AttributeExpression",
            "args": [
                "attributeName": attributeExpression.attributeName,
                "expression": attributeExpression.expression,
                "rerender": rerender
            ]
        ])!
    }
}

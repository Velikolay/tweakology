//
//  UpdateAttributeWithRerenderAction.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 26.07.19.
//

import Foundation

@available(iOS 10.0, *)
class UpdateAttributeWithRerenderAction: UpdateAttributeAction {
    private var tweakologyLayoutEngine: TweakologyLayoutEngine
    private var attributeIndexer: AttributeIndexer

    init(
        tweakologyLayoutEngine: TweakologyLayoutEngine,
        attributeIndexer: AttributeIndexer,
        attributeStore: AttributeStore,
        expressionProcessor: ExpressionProcessor,
        attributeExpression: AttributeExpression
    ) {
        self.tweakologyLayoutEngine = tweakologyLayoutEngine
        self.attributeIndexer = attributeIndexer
        super.init(attributeStore: attributeStore, expressionProcessor: expressionProcessor, attributeExpression: attributeExpression)
    }
    
    override func execute() {
        super.execute()
        if let changeSeq = self.attributeIndexer.getIndex()[self.attributeExpression.attributeName]?.map({
            [
                "operation": "modify",
                "view": $0
            ]
        }) {
            self.tweakologyLayoutEngine.tweak(changeSeq: changeSeq)
        }
    }
}

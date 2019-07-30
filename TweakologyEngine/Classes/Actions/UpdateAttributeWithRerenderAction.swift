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
    private var tweakologyStorage: TweakologyStorage

    init(tweakologyLayoutEngine: TweakologyLayoutEngine, tweakologyStorage: TweakologyStorage, contextStore: AttributeStore, expressionProcessor: ExpressionProcessor, attributeExpression: AttributeExpression) {
        self.tweakologyLayoutEngine = tweakologyLayoutEngine
        self.tweakologyStorage = tweakologyStorage
        super.init(contextStore: contextStore, expressionProcessor: expressionProcessor, attributeExpression: attributeExpression)
    }
    
    override func execute() {
        super.execute()
        let changeSeq: [[String: Any]] = []
        let tweaks = self.tweakologyStorage.getAllTweaks()
    }
}

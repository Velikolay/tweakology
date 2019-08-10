//
//  ActionFactory.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 9.08.19.
//

import Foundation

@available(iOS 10.0, *)
class ActionFactory {
    static let sharedInstance = ActionFactory(
        tweakologyLayoutEngine: TweakologyLayoutEngine.sharedInstance,
        attributeStore: InMemoryAttributeStore.sharedInstance,
        attributeIndexer: AttributeIndexer.sharedInstance,
        expressionProcessor: LiquidExpressionProcessor(),
        httpClient: URLSessionAsyncHTTPClient()
    )
    
    private var tweakologyLayoutEngine: TweakologyLayoutEngine
    private var attributeStore: AttributeStore
    private var attributeIndexer: AttributeIndexer
    private var expressionProcessor: ExpressionProcessor
    private var httpClient: AsyncHTTPClient
    
    init(
        tweakologyLayoutEngine: TweakologyLayoutEngine,
        attributeStore: AttributeStore,
        attributeIndexer: AttributeIndexer,
        expressionProcessor: ExpressionProcessor,
        httpClient: AsyncHTTPClient
    ) {
        self.attributeStore = attributeStore
        self.attributeIndexer = attributeIndexer
        self.expressionProcessor = expressionProcessor
        self.tweakologyLayoutEngine = tweakologyLayoutEngine
        self.httpClient = httpClient
    }
    
    func getUpdateAttributeAction(attributeExpression: AttributeExpression) -> Action {
        return UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: attributeExpression)
    }
    
    func getUpdateAttributeWithRerenderAction(attributeExpression: AttributeExpression) -> Action {
        return UpdateAttributeWithRerenderAction(tweakologyLayoutEngine: self.tweakologyLayoutEngine, attributeIndexer: self.attributeIndexer, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: attributeExpression)
    }
    
    func getHTTPRequestAction(urlExpression: String, attributeName: String?) -> Action {
        return HTTPRequestAction(httpClient: self.httpClient, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, urlExpression: urlExpression, attributeName: attributeName)
    }
}

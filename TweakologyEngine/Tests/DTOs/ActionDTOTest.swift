//
//  ActionDTOTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 10.08.19.
//

import XCTest
@testable import TweakologyEngine
import Nimble

@available(iOS 10.0, *)
class ActionDTOTest: XCTestCase {
    var actionFactory: ActionFactory!
    
    override func setUp() {
        super.setUp()
        self.actionFactory = ActionFactory(
            tweakologyLayoutEngine: TweakologyLayoutEngine(),
            attributeStore: InMemoryAttributeStore(),
            attributeIndexer: AttributeIndexer(),
            expressionProcessor: LiquidExpressionProcessor(),
            httpClient: URLSessionAsyncHTTPClient()
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateAttributeAction() {
        let actionDTO = ActionDTO(JSON: [
            "type": "UpdateAttribute",
            "args": [
                "attributeName": "TestAttr",
                "expression": "{{ TestAttr | capitalize }}",
                "valueType": "integer",
                "defaultValue": 0
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? UpdateAttributeAction).toNot(beNil())
    }
    
    func testUpdateAttributeActionEmptyJson() {
        let actionDTO = ActionDTO(JSON: [:])
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? UpdateAttributeAction).to(beNil())
    }
    
    func testUpdateAttributeActionNoArgs() {
        let actionDTO = ActionDTO(JSON: [
            "type": "UpdateAttribute"
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? UpdateAttributeAction).to(beNil())
    }
    
    func testUpdateAttributeWithRerenderAction() {
        let actionDTO = ActionDTO(JSON: [
            "type": "UpdateAttributeWithRerender",
            "args": [
                "attributeName": "TestAttr",
                "expression": "{{ TestAttr | capitalize }}",
                "valueType": "integer",
                "defaultValue": 0
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? UpdateAttributeWithRerenderAction).toNot(beNil())
    }
    
    func testUpdateAttributeWithRerenderActionNoArgs() {
        let actionDTO = ActionDTO(JSON: [
            "type": "UpdateAttributeWithRerender"
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? UpdateAttributeWithRerenderAction).to(beNil())
    }
    
    func testHTTPRequestAction() {
        let actionDTO = ActionDTO(JSON: [
            "type": "HTTPRequestAction",
            "args": [
                "attributeName": "TestAttr",
                "urlExpression": "https://domain.com",
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? HTTPRequestAction).toNot(beNil())
    }
    
    func testHTTPRequestActionNoArgs() {
        let actionDTO = ActionDTO(JSON: [
            "type": "HTTPRequestAction"
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? HTTPRequestAction).to(beNil())
    }
}

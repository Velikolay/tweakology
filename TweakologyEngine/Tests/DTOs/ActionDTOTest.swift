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
    
    func testAttributeExpressionAction() {
        let actionDTO = ActionDTO(JSON: [
            "id": "id",
            "type": "AttributeExpression",
            "args": [
                "rerender": true,
                "attributeName": "TestAttr",
                "expression": "{{ TestAttr | capitalize }}",
                "valueType": "integer",
                "defaultValue": 0
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).toNot(beNil())
    }
    
    func testAttributeExpressionActionWithoutRerender() {
        let actionDTO = ActionDTO(JSON: [
            "id": "id",
            "type": "AttributeExpression",
            "args": [
                "attributeName": "TestAttr",
                "expression": "{{ TestAttr | capitalize }}",
                "valueType": "integer",
                "defaultValue": 0
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).toNot(beNil())
    }
    
    func testAttributeExpressionActionEmptyJson() {
        let actionDTO = ActionDTO(JSON: [:])
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).to(beNil())
    }
    
    func testAttributeExpressionActionNoArgs() {
        let actionDTO = ActionDTO(JSON: [
            "id": "id",
            "type": "AttributeExpression"
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).to(beNil())
    }
    
    func testAttributeExpressionActionNoId() {
        let actionDTO = ActionDTO(JSON: [
            "type": "AttributeExpression",
            "args": [
                "attributeName": "TestAttr",
                "expression": "{{ TestAttr | capitalize }}",
                "valueType": "integer",
                "defaultValue": 0
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).to(beNil())
    }
    
    func testHTTPRequestAction() {
        let actionDTO = ActionDTO(JSON: [
            "id": "id",
            "type": "HTTPRequest",
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
            "id": "id",
            "type": "HTTPRequest"
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? HTTPRequestAction).to(beNil())
    }
    
    func testHTTPRequestActionNoId() {
        let actionDTO = ActionDTO(JSON: [
            "type": "HTTPRequest",
            "args": [
                "attributeName": "TestAttr",
                "urlExpression": "https://domain.com",
            ]
        ])
        
        let action = actionDTO?.toAction(actionFactory: self.actionFactory)
        expect(action as? AttributeExpressionAction).to(beNil())
    }
}

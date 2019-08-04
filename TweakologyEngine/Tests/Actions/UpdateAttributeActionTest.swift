//
//  UpdateAttributeActionTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 4.08.19.
//

import XCTest
@testable import TweakologyEngine
import Nimble

class UpdateAttributeActionTest: XCTestCase {
    var attributeStore: AttributeStore!
    var expressionProcessor: ExpressionProcessor!
    
    override func setUp() {
        super.setUp()
        self.attributeStore = InMemoryAttributeStore()
        self.expressionProcessor = LiquidExpressionProcessor()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateExistingStringAttribute() {
        self.attributeStore.set(key: "TestAttr", value: "test")
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | capitalize }}", valueType: AttributeType.string)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("Test"))
    }
    
    func testUpdateNonExistingStringAttributeWithDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | capitalize }}", valueType: AttributeType.string, defaultValue: "test")
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("Test"))
    }
    
    func testUpdateNonExistingStringAttributeWithoutDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | append: \"test\" }}", valueType: AttributeType.string)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("test"))
    }
    
    func testUpdateExistingStringAttributeValueDependingOnAnotherAttribute() {
        self.attributeStore.set(key: "TestAttr1", value: "test")
        self.attributeStore.set(key: "TestAttr2", value: "test")
        let expr = AttributeExpression(attributeName: "TestAttr2", expression: "{{ TestAttr1 | capitalize }}", valueType: AttributeType.string)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr1") as? String).to(equal("test"))
        expect(self.attributeStore.get(key: "TestAttr2") as? String).to(equal("Test"))
    }
    
    func testUpdateExistingIntAttribute() {
        self.attributeStore.set(key: "TestAttr", value: 2)
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | plus: 4 }}", valueType: AttributeType.integer)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? Int).to(equal(6))
    }
    
    func testUpdateNonExistingIntAttributeWithDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | plus: 4 }}", valueType: AttributeType.integer, defaultValue: 2)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? Int).to(equal(6))
    }
    
    func testUpdateNonExistingIntAttributeWithoutDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | plus: 4 }}", valueType: AttributeType.integer)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? Int).to(equal(4))
    }

}

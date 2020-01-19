//
//  UpdateAttributeWithRerenderActionTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 4.08.19.
//

import XCTest
@testable import TweakologyEngine
import Nimble

@available(iOS 10.0, *)
class UpdateAttributeWithRerenderActionTest: XCTestCase {
    var attributeIndexer: AttributeIndexer!
    var attributeStore: AttributeStore!
    var expressionProcessor: ExpressionProcessor!

    override func setUp() {
        super.setUp()
        self.attributeStore = InMemoryAttributeStore()
        self.expressionProcessor = LiquidExpressionProcessor()
        self.attributeIndexer = AttributeIndexer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateExistingStringAttribute() {
        self.attributeStore.set(key: "TestAttr", value: "test")
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | capitalize }}", valueType: AttributeType.string)
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("Test"))
    }
    
    func testUpdateNonExistingStringAttributeWithDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | capitalize }}", valueType: AttributeType.string, defaultValue: "test")
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("Test"))
    }
    
    func testUpdateNonExistingStringAttributeWithoutDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | append: \"test\" }}", valueType: AttributeType.string)
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("test"))
    }
    
    func testUpdateExistingStringAttributeValueDependingOnAnotherAttribute() {
        self.attributeStore.set(key: "TestAttr1", value: "test")
        self.attributeStore.set(key: "TestAttr2", value: "test")
        let expr = AttributeExpression(attributeName: "TestAttr2", expression: "{{ TestAttr1 | capitalize }}", valueType: AttributeType.string)
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr1") as? String).to(equal("test"))
        expect(self.attributeStore.get(key: "TestAttr2") as? String).to(equal("Test"))
    }
    
    func testUpdateNonExistingIntAttributeWithDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | plus: 4 }}", valueType: AttributeType.integer, defaultValue: 2)
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? Int).to(equal(6))
    }
    
    func testUpdateNonExistingIntAttributeWithoutDefaultValue() {
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | plus: 4 }}", valueType: AttributeType.integer)
        AttributeExpressionAction(id: "id", attributeExpression: expr, attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? Int).to(equal(4))
    }
    
    // Note: the order of invokations is not being tested
    func testRerenderViewAfterAttributeUpdate() {
        let change: [String: Any] = [
            "operation": "insert",
            "view" : [
                "id": "testLabel",
                "properties" : [
                    "text": "{{ TestAttr }}",
                    "font": "NewTimesRoman"
                ]
            ]
        ]
        
        class MockTweakologyLayoutEngine: TweakologyLayoutEngine {
            override init() {
                super.init()
            }
            override func tweak(changeSeq: [[String : Any]]) {
                expect(changeSeq.count).to(equal(1))
                expect(changeSeq[0]["operation"] as? String).to(equal("modify"))
                expect(getViewId(change: changeSeq[0])).to(equal("testLabel"))
                expect(getViewProperties(change: changeSeq[0])).to(equal(["text": "{{ TestAttr }}"]))
            }
        }
        
        let tweakologyLayoutEngineMock = MockTweakologyLayoutEngine()
        let expr = AttributeExpression(attributeName: "TestAttr", expression: "{{ TestAttr | capitalize }}", valueType: AttributeType.string)
        self.attributeIndexer.index(change: change)
        self.attributeStore.set(key: "TestAttr", value: "test")
        AttributeExpressionAction(
            id: "id",
            attributeExpression: expr,
            rerender: true,
            attributeStore: self.attributeStore,
            expressionProcessor: self.expressionProcessor,
            tweakologyLayoutEngine: tweakologyLayoutEngineMock,
            attributeIndexer: self.attributeIndexer
        ).execute()
        expect(self.attributeStore.get(key: "TestAttr") as? String).to(equal("Test"))
    }
}

func getViewId(change: [String: Any]) -> String? {
    if let view = change["view"] as? [String: Any] {
        return getId(view: view)
    }
    return nil
}

func getId(view: [String: Any]) -> String? {
    if let id = view["id"] as? String {
        return id
    }
    return nil
}

func getProperties(view: [String: Any]) -> [String: String]? {
    if let properties = view["properties"] as? [String: String] {
        return properties
    }
    return nil
}

func getViewProperties(change: [String: Any]) -> [String: String]? {
    if let view = change["view"] as? [String: Any] {
        return getProperties(view: view)
    }
    return nil
}

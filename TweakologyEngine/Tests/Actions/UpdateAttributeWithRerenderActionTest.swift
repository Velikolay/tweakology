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
        UpdateAttributeWithRerenderAction(
            tweakologyLayoutEngine: tweakologyLayoutEngineMock,
            attributeIndexer: self.attributeIndexer,
            attributeStore: self.attributeStore,
            expressionProcessor: self.expressionProcessor,
            attributeExpression: expr
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

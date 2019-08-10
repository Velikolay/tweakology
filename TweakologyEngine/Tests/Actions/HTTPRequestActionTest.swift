//
//  HTTPRequestActionTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 8.08.19.
//

import XCTest
@testable import TweakologyEngine
import Nimble



class HTTPRequestActionTest: XCTestCase {
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

    func testLoadAttributeFromGetUrl() {
        class MockAsyncHTTPClient: AsyncHTTPClient {
            func get(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
                expect(url).to(equal("https://domain?key=val"))
                let string = "{\"id\":3456,\"name\":\"test\"}"
                let data = string.data(using: .utf8)!
                completionHandler(data, nil, nil)
            }
        }
        
        self.attributeStore.set(key: "QueryString", value: "key=val")
        let urlExpression = "https://domain?{{ QueryString }}"
        HTTPRequestAction(httpClient: MockAsyncHTTPClient(), attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, urlExpression: urlExpression, attributeName: "RespAttr").execute()
        let attr = self.attributeStore.get(key: "RespAttr") as? [String: Any]
        expect(attr).toNot(be(nil))
        expect(attr!["id"] as? Int).to(equal(3456))
        expect(attr!["name"] as? String).to(equal("test"))
        
        let expr = AttributeExpression(attributeName: "Id", expression: "{{ RespAttr.id | plus: 4 }}", valueType: AttributeType.integer)
        UpdateAttributeAction(attributeStore: self.attributeStore, expressionProcessor: self.expressionProcessor, attributeExpression: expr).execute()
        expect(self.attributeStore.get(key: "Id") as? Int).to(equal(3460))
    }

}

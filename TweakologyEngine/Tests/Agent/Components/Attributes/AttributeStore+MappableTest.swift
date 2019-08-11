//
//  AttributeStore+MappableTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 11.08.19.
//

import XCTest
import Nimble
@testable import TweakologyEngine

class AttributeStore_MappableTest: XCTestCase {
    var attributeStore: AttributeStore!

    override func setUp() {
        self.attributeStore = InMemoryAttributeStore()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInMemoryAttributeStoreSerialisation() {
        self.attributeStore.set(key: "StrAttr", value: "str")
        self.attributeStore.set(key: "IntAttr", value: 3)
        self.attributeStore.set(key: "BoolAttr", value: true)
        self.attributeStore.set(key: "DoubleAttr", value: 1.3)
        self.attributeStore.set(key: "NestedAttr", value: ["StrAttr": "str"])
        
        let mappable = self.attributeStore as? MappableAttributeStore
        expect(mappable).toNot(beNil())
        let storeJson = mappable?.toJSON()
        expect(storeJson).toNot(beNil())
        expect(storeJson?["StrAttr"] as? String).to(equal("str"))
        expect(storeJson?["IntAttr"] as? Int).to(equal(3))
        expect(storeJson?["BoolAttr"] as? Bool).to(equal(true))
        expect(storeJson?["DoubleAttr"] as? Double).to(equal(1.3))
        expect(storeJson?["NestedAttr"] as? [String: String]).to(equal(["StrAttr": "str"]))
    }

}

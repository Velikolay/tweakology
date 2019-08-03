//
//  AttributeIndexerTest.swift
//  TweakologyEngine_Tests
//
//  Created by Nikolay Ivanov on 3.08.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import TweakologyEngine
import Nimble

class AttributeIndexerTest: XCTestCase {
    var indexer: AttributeIndexer!
    override func setUp() {
        super.setUp()
        self.indexer = AttributeIndexer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndexSingleAttribute() {
        let change = self.genChange(id: "testLabel", textValue: "{{ TextAttribute }}")
        self.indexer.index(change: change)
        
        expect(self.indexer.getIndex().count).to(equal(1))
        let attr = self.indexer.getIndex()["TextAttribute"]
        expect(attr).notTo(beNil())
        expect(attr?.count).to(equal(1))
        expect(self.getId(view: attr![0])).to(equal(self.getViewId(change: change)))
        expect(self.getProperties(view: attr![0])).to(equal(self.getViewProperties(change: change)))
    }
    
    func testIndexNoAttribute() {
        let change = self.genChange(id: "testLabel", textValue: "Text")
        self.indexer.index(change: change)
        
        expect(self.indexer.getIndex().count).to(equal(0))
    }
    
    func testIndexTwoAttributesSingleView() {
        let change = self.genChange(id: "testLabel", textValue: "{{ TextAttribute }}", fontValue: "{{ FontAttribute }}")
        self.indexer.index(change: change)
        
        expect(self.indexer.getIndex().count).to(equal(2))
        let attr1 = self.indexer.getIndex()["TextAttribute"]
        let attr2 = self.indexer.getIndex()["FontAttribute"]
        
        expect(attr1).notTo(beNil())
        expect(attr1?.count).to(equal(1))
        expect(self.getId(view: attr1![0])).to(equal(self.getViewId(change: change)))
        expect(self.getProperties(view: attr1![0])).to(equal(self.getViewProperties(change: self.genChange(id: "testLabel", textValue: "{{ TextAttribute }}"))))
        
        expect(attr2).notTo(beNil())
        expect(attr2?.count).to(equal(1))
        expect(self.getId(view: attr2![0])).to(equal(self.getViewId(change: change)))
        expect(self.getProperties(view: attr2![0])).to(equal(self.getViewProperties(change: self.genChange(id: "testLabel", fontValue: "{{ FontAttribute }}"))))
    }
    
    func testIndexTwoAttributesSingleViewFromTwoChanges() {
        let change1 = self.genChange(id: "testLabel", textValue: "{{ TextAttribute }}")
        let change2 = self.genChange(id: "testLabel", fontValue: "{{ FontAttribute }}")

        self.indexer.index(change: change1)
        self.indexer.index(change: change2)
        
        expect(self.indexer.getIndex().count).to(equal(2))
        let attr1 = self.indexer.getIndex()["TextAttribute"]
        let attr2 = self.indexer.getIndex()["FontAttribute"]
        
        expect(attr1).notTo(beNil())
        expect(attr1?.count).to(equal(1))
        expect(self.getId(view: attr1![0])).to(equal(self.getViewId(change: change1)))
        expect(self.getProperties(view: attr1![0])).to(equal(self.getViewProperties(change: change1)))
        
        expect(attr2).notTo(beNil())
        expect(attr2?.count).to(equal(1))
        expect(self.getId(view: attr2![0])).to(equal(self.getViewId(change: change2)))
        expect(self.getProperties(view: attr2![0])).to(equal(self.getViewProperties(change: change2)))
    }
    
    func testIndexSingleAttributeTwoViews() {
        let change1 = self.genChange(id: "testLabel1", textValue: "{{ TextAttribute }}")
        let change2 = self.genChange(id: "testLabel2", textValue: "{{ TextAttribute }}")
        
        self.indexer.index(change: change1)
        self.indexer.index(change: change2)
        
        expect(self.indexer.getIndex().count).to(equal(1))
        let attr = self.indexer.getIndex()["TextAttribute"]
        
        expect(attr).notTo(beNil())
        expect(attr?.count).to(equal(2))
        expect(self.getId(view: attr![0])).to(equal(self.getViewId(change: change1)))
        expect(self.getProperties(view: attr![0])).to(equal(self.getViewProperties(change: change1)))
        expect(self.getId(view: attr![1])).to(equal(self.getViewId(change: change2)))
        expect(self.getProperties(view: attr![1])).to(equal(self.getViewProperties(change: change2)))
    }
    
    private func getViewId(change: [String: Any]) -> String? {
        if let view = change["view"] as? [String: Any] {
            return self.getId(view: view)
        }
        return nil
    }
    
    private func getId(view: [String: Any]) -> String? {
        if let id = view["id"] as? String {
            return id
        }
        return nil
    }
    
    private func getProperties(view: [String: Any]) -> [String: String]? {
        if let properties = view["properties"] as? [String: String] {
            return properties
        }
        return nil
    }
    
    private func getViewProperties(change: [String: Any]) -> [String: String]? {
        if let view = change["view"] as? [String: Any] {
            return self.getProperties(view: view)
        }
        return nil
    }
    
    private func genChange(id: String, textValue: String? = nil, fontValue: String? = nil) -> [String: Any] {
        var properties: [String: String] = [:]
        if let textValue = textValue {
            properties["text"] = "\(textValue)"
        }
        if let fontValue = fontValue {
            properties["font"] = "\(fontValue)"
        }
        return [
            "operation": "insert",
            "view" : [
                "id": "\(id)",
                "properties" : properties
            ]
        ]
    }
}

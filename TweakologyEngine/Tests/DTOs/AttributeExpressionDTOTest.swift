//
//  AttributeExpressionDTOTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 10.08.19.
//

import XCTest
@testable import TweakologyEngine
import Nimble

class AttributeExpressionDTOTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributeExpressionDTO() {
        let attributeExpressionDTO = AttributeExpressionDTO(JSON: [
            "attributeName": "TestAttr",
            "expression": "{{ TestAttr | capitalize }}",
            "valueType": "integer",
            "defaultValue": 0
        ])
        
        expect(attributeExpressionDTO?.toAttributeExpression()).toNot(beNil())
    }
    
    func testNoDefaultValueAttributeExpressionDTO() {
        let attributeExpressionDTO = AttributeExpressionDTO(JSON: [
            "attributeName": "TestAttr",
            "expression": "{{ TestAttr | capitalize }}",
            "valueType": "integer"
        ])
        
        expect(attributeExpressionDTO?.toAttributeExpression()).toNot(beNil())
    }
    
    func testNoValueTypeAttributeExpressionDTO() {
        let attributeExpressionDTO = AttributeExpressionDTO(JSON: [
            "attributeName": "TestAttr",
            "expression": "{{ TestAttr | capitalize }}",
            "defaultValue": 0
        ])
        
        expect(attributeExpressionDTO?.toAttributeExpression()).to(beNil())
    }
    
    func testNoAttributeNameAttributeExpressionDTO() {
        let attributeExpressionDTO = AttributeExpressionDTO(JSON: [
            "expression": "{{ TestAttr | capitalize }}",
            "valueType": "integer",
            "defaultValue": 0
        ])
        
        expect(attributeExpressionDTO?.toAttributeExpression()).to(beNil())
    }
    
    func testNoExpressionAttributeExpressionDTO() {
        let attributeExpressionDTO = AttributeExpressionDTO(JSON: [
            "attributeName": "TestAttr",
            "valueType": "integer",
            "defaultValue": 0
        ])
        
        expect(attributeExpressionDTO?.toAttributeExpression()).to(beNil())
    }

}

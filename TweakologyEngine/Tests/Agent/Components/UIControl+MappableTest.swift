//
//  UIControl+MappableTest.swift
//  TweakologyEngine-Unit-Tests
//
//  Created by Nikolay Ivanov on 18.08.19.
//

import XCTest
import Nimble

class UIControl_MappableTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUIControlEvent() {
        let touchUpInside = UIControl.Event.touchUpInside.toJSON()
        expect(touchUpInside).toNot(beNil())
        expect(touchUpInside["value"] as? UInt).to(equal(64))
        
        let touchUpOutside = UIControl.Event.touchUpOutside.toJSON()
        expect(touchUpOutside).toNot(beNil())
        expect(touchUpOutside["value"] as? UInt).to(equal(128))
    }

}

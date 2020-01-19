//
//  Event.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

let ControlEvents = [
    "TouchUpInside": UIControl.Event.touchUpInside,
    "TouchUpOutside": UIControl.Event.touchUpOutside,
    "TouchDragInside": UIControl.Event.touchDragInside,
    "TouchDragOutside": UIControl.Event.touchDragOutside,
    "TouchDragEnter": UIControl.Event.touchDragEnter,
    "TouchDragExit": UIControl.Event.touchDragExit,
    "TouchDownRepeat": UIControl.Event.touchDownRepeat,
    "TouchDown": UIControl.Event.touchDown,
    "TouchCancel": UIControl.Event.touchCancel,
    "ValueChanged": UIControl.Event.valueChanged
]

class Event {
    public let name: String
    public var control: UIControl.Event?

    init(name: String) {
        self.name = name
        self.control = ControlEvents[name]
    }
}

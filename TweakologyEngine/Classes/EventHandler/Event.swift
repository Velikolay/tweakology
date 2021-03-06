//
//  Event.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

let NameToControlEvent = [
    "TouchUpInside": UIControl.Event.touchUpInside,
    "TouchUpOutside": UIControl.Event.touchUpOutside,
    "TouchDragInside": UIControl.Event.touchDragInside,
    "TouchDragOutside": UIControl.Event.touchDragOutside,
    "TouchDragEnter": UIControl.Event.touchDragEnter,
    "TouchDragExit": UIControl.Event.touchDragExit,
    "TouchDownRepeat": UIControl.Event.touchDownRepeat,
    "TouchDown": UIControl.Event.touchDown,
    "TouchCancel": UIControl.Event.touchCancel,
    "ValueChanged": UIControl.Event.valueChanged,
    "EditingChanged": UIControl.Event.editingChanged
]

class Event {
    private(set) var name: String?
    private(set) var control: UIControl.Event?

    init(name: String) {
        self.name = name
        self.control = NameToControlEvent[name]
    }
    
    init(control: UIControl.Event) {
        self.control = control
        if let idx = NameToControlEvent.values.index(of: control) {
            self.name = NameToControlEvent.keys[idx]
        }
    }
}

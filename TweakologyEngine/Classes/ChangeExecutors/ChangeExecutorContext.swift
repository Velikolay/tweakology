//
//  ChangeExecutorContext.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 23.01.20.
//

import Foundation

@available(iOS 10.0, *)
struct ChangeExecutorContext {
    let viewIndex: [String: UIView]
    let eventHandlerIndex: [String: EventHandler]
    let actionIndex: [String: Action]
    let mode: EngineMode
    
    init(viewIndex: [String: UIView], eventHandlerIndex: [String: EventHandler], actionIndex: [String: Action], mode: EngineMode) {
        self.viewIndex = viewIndex
        self.eventHandlerIndex = eventHandlerIndex
        self.actionIndex = actionIndex
        self.mode = mode
    }
}

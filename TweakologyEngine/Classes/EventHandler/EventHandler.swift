//
//  EventHandler.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 14.01.20.
//

import Foundation

@available(iOS 10.0, *)
class EventHandler: EventHandlerProtocol {
    private var id: String
    private var events: [String]
    private var actions: [String]
    private var index: [String: Action]
    
    init(id: String, events: [String], actions: [String], index: [String: Action]) {
        self.id = id
        self.events = events
        self.actions = actions
        self.index = index
    }
    
    func getId() -> String {
        return self.id
    }
    
    func handle(event: String) {
        if self.events.index(of: event) != nil {
            for actionId in self.actions {
                self.index[actionId]?.execute()
            }
        }
    }
    
    func toDTO() -> EventHandlerDTO {
        return EventHandlerDTO(JSON: [
            "id": id,
            "events": events,
            "actions": actions
        ])!
    }
}

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
    private var actionIndex: [String: Action]

    init(id: String, events: [String], actions: [String], actionIndex: [String: Action]) {
        self.id = id
        self.events = events
        self.actions = actions
        self.actionIndex = actionIndex
    }

    func getId() -> String {
        return self.id
    }

    func handle(event: String) {
        if self.events.index(of: event) != nil {
            for actionId in self.actions {
                self.actionIndex[actionId]?.execute()
            }
        }
    }

    func getEvents() -> [Event] {
        return self.events.map { (name) -> Event in
            Event(name: name)
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

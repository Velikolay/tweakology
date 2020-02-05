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
    private var context: EngineContext

    init(id: String, events: [String], actions: [String], context: EngineContext) {
        self.id = id
        self.events = events
        self.actions = actions
        self.context = context
    }

    func getId() -> String {
        return self.id
    }

    func handle(event: String) {
        if self.events.index(of: event) != nil {
            for actionId in self.actions {
                self.context.actionIndex[actionId]?.execute()
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

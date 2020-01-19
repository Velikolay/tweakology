//
//  EventHandlerDTO.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 18.01.20.
//

import Foundation
import ObjectMapper

@available(iOS 10.0, *)
class EventHandlerDTO: Mappable {
    var id: String!
    var events: [String]!
    var actions: [String]!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        events <- map["events"]
        actions <- map["actions"]
    }
    
    func toEventHandler(index: [String: Action]) -> EventHandler {
        return EventHandler(id: id, events: events, actions: actions, index: index)
    }
}

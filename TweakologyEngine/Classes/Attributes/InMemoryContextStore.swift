//
//  InMemoryContextStore.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.07.19.
//

import Foundation

class InMemoryContextStore: ContextStore {
    private var context: [String: Any] = [:]
    
    func set(key: String, value: Any) {
        self.context[key] = value
    }
    
    func get(key: String) -> Any? {
        return self.context[key]
    }
    
    func getAll() -> [String: Any] {
        return self.context
    }
}

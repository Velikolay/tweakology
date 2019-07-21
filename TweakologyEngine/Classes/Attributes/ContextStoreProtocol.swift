//
//  ContextStoreProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.07.19.
//

import Foundation

protocol ContextStore {
    func set(key: String, value: Any)
    func get(key: String) -> Any?
    func getAll() -> [String: Any]
}

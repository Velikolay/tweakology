//
//  TweakologyStorage.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 6/27/18.
//

import Foundation

@objc public class TweakologyStorage: NSObject {
    @objc public static let sharedInstance = TweakologyStorage()

    private var storage: [String: [[String: Any]]]

    private override init() {
        storage = [:]
    }

    @objc public func addTweak(name: String, changeSet: [[String: Any]]) {
        storage[name] = changeSet
    }
    
    @objc public func getTweak(name: String) -> [[String: Any]]? {
        return storage[name]
    }
    
    @objc public func getAllTweaks() -> [String: [[String: Any]]] {
        return storage
    }
}

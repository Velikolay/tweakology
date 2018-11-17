//
//  TweakologyStorage.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 6/27/18.
//

import Foundation

public class TweakologyStorage: NSObject {
    public static let sharedInstance = TweakologyStorage()

    private var storage: [String: [[String: Any]]]

    private override init() {
        storage = [:]
    }

    public func addTweak(name: String, changeSet: [[String: Any]]) {
        storage[name] = changeSet
    }
    
    public func getTweak(name: String) -> [[String: Any]]? {
        return storage[name]
    }
    
    public func getAllTweaks() -> [String: [[String: Any]]] {
        return storage
    }
}



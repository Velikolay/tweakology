//
//  TweaksStorage.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 6/27/18.
//

import Foundation

public class TweaksStorage {
    public static let sharedInstance = TweaksStorage()

    private var storage: [String: [[String: Any]]]

    private init() {
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



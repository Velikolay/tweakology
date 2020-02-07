//
//  AttributeIndexer.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 2.08.19.
//

import Foundation

class AttributeIndexer {
    static let sharedInstance = AttributeIndexer()
    private var index: [String: [[String: Any]]]
    
    init() {
        self.index = [:]
    }
    
    func getIndex() -> [String: [[String: Any]]] {
        return index
    }
    
    func index(change: [String: Any]) {
        if let viewId = change["id"] as? String {
            for changeSection in ["properties", "layer"] {
                if let dict = change[changeSection] as? [String: Any] {
                    let idx = self.indexByAttribute(dict: dict)
                    for (attributeName, change) in idx {
                        self.mergeToIndex(attributeName: attributeName, viewId: viewId, changeSection: changeSection, change: change)
                    }
                }
            }
        }
    }
    
    private func mergeToIndex(attributeName: String, viewId: String, changeSection: String, change: [String: Any]) {
        if !change.isEmpty {
            var attr = self.index[attributeName] ?? []
            
            let optView = attr.first(where: { (view) -> Bool in
                view["id"] as? String == viewId
            })
            let viewExists = optView != nil
            var view = optView ?? [ "id": viewId ]
            var changes = view[changeSection] as? [String: Any] ?? [:]
            
            self.mergeChanges(changes: &changes, newChange: change)
            view[changeSection] = changes
            
            if !viewExists {
                attr.append(view)
            }
            self.index[attributeName] = attr
        }
    }
    
    private func mergeChanges(changes: inout [String: Any], newChange: [String: Any]) {
        for (key, val) in newChange {
            if var c1 = changes[key] as? [String: Any], let c2 = val as? [String: Any] {
                self.mergeChanges(changes: &c1, newChange: c2)
            } else {
                changes[key] = val
            }
        }
    }
    
    private func indexByAttribute(dict: [String: Any]) -> [String: [String: Any]] {
        var res: [String: [String: Any]] = [:]
        for (key, val) in dict {
            if let str = val as? String, let attributeName = self.parseAttributeName(str: str) {
                if res[attributeName] == nil {
                    res[attributeName] = [:]
                }
                res[attributeName]?[key] = val
            }
            if let dict = val as? [String: Any] {
                let subres = self.indexByAttribute(dict: dict)
                for (attributeName, val) in subres {
                    if res[attributeName] == nil {
                        res[attributeName] = [:]
                    }
                    res[attributeName]?[key] = val
                }
            }
        }
        return res
    }
    
    private func parseAttributeName(str: String) -> String? {
        let pattern = "^\\s*\\{\\{\\s*([a-zA-Z0-9._-]+)\\s*\\}\\}\\s*$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        guard let match = regex.firstMatch(in: str, options: [], range: NSRange(str.startIndex..., in: str)) else { return nil }
        return String(str[Range(match.range(at: 1), in: str)!])
    }
}

//
//  AttributeStore+Mappable.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 11.08.19.
//

import Foundation
import ObjectMapper

protocol MappableAttributeStore: AttributeStore, StaticMappable {}

extension InMemoryAttributeStore: MappableAttributeStore {
    static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    func mapping(map: Map) {
        for (key, val) in self.getAll() {
            val >>> map[key]
        }
    }
}

//
//  UIScrollView+MappableOverride.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 18.01.19.
//

import Foundation
import ObjectMapper

extension UIScrollView: MappableOverride {
    public static func objectForMappingOverride(map: Map) -> BaseMappable? {
        return nil
    }

    public func mappingOverride(map: Map) {
        contentOffset >>> map["properties.contentOffset"]
        contentSize >>> map["properties.contentSize"]
    }
}

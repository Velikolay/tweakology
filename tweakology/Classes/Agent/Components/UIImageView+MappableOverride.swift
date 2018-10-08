//
//  UIImageView+MappableOverride.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/8/18.
//

import Foundation
import ObjectMapper

extension UIImageView: MappableOverride {
    public static func objectForMappingOverride(map: Map) -> BaseMappable? {
        return nil
    }

    public func mappingOverride(map: Map) {
        image >>> map["properties.image"]
        highlightedImage >>> map["properties.highlightedImage"]
    }
}

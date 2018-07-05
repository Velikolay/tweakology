//
//  UIView+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/15/18.
//

import Foundation
import ObjectMapper

extension UIView: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        String(describing:type(of: self)) >>> map["type"]
        frame <- map["properties.frame"]
        backgroundColor <- map["properties.backgroundColor"]
        hierarchyMetadata >>> map["hierarchyMetadata"]
        uid >>> map["uid"]
        if var mappableOverride = self as? MappableOverride {
            mappableOverride.mappingOverride(map: map)
        }

        if !subviews.isEmpty {
            subviews >>> map["subviews"]
        }
    }
}

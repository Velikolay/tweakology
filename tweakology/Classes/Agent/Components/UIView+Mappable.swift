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
        frame <- map["frame"]
        backgroundColor <- map["backgroundColor"]
        hierarchyMetadata >>> map["hierarchyMetadata"]
        if var mappableOverride = self as? MappableOverride {
            mappableOverride.mappingOverride(map: map)
        }

        if !subviews.isEmpty {
            subviews >>> map["subviews"]
        }
    }
}

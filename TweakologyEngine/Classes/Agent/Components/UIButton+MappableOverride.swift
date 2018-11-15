//
//  UIButton+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/14/18.
//

import Foundation
import ObjectMapper

extension UIButton: MappableOverride {
    public static func objectForMappingOverride(map: Map) -> BaseMappable? {
        return nil
    }

    public func mappingOverride(map: Map) {
        let obj = Map(mappingType: .toJSON, JSON: [:])
        titleLabel >>> obj["title"]
        if let title = obj.JSON["title"] as? [String: Any], let titleProperties = title["properties"] {
            titleProperties >>> map["properties.title"]
        }
    }
}

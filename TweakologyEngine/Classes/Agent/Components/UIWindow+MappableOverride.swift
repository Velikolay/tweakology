//
//  UIWindow+MappableOverride.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/25/18.
//

import Foundation
import ObjectMapper

extension UIWindow: MappableOverride {
    public static func objectForMappingOverride(map: Map) -> BaseMappable? {
        return nil
    }

    public func mappingOverride(map: Map) {
        generateUID() >>> map["uid.value"]
        UIViewIdentifierKind.generated >>> map["uid.kind"]
    }
}

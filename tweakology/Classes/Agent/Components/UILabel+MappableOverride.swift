//
//  UILabel+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/14/18.
//

import Foundation
import ObjectMapper

extension UILabel: MappableOverride {
    public static func objectForMappingOverride(map: Map) -> BaseMappable? {
        return nil
    }

    public func mappingOverride(map: Map) {
        text <- map["text"]
        textColor <- map["textColor"]
        font <- map["font"]
    }

}

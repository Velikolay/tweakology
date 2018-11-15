//
//  UIFont+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/15/18.
//

import Foundation
import ObjectMapper

extension UIFont: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        fontName >>> map["fontName"]
        pointSize >>> map["pointSize"]
        familyName >>> map["familyName"]
        fontDescriptor.symbolicTraits.rawValue >>> map["trait"]
    }
}

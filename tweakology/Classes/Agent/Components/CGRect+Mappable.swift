//
//  CGRect+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/17/18.
//

import Foundation
import ObjectMapper

extension CGRect: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        minX >>> map["minX"]
        minY >>> map["minY"]
        maxX >>> map["maxX"]
        maxY >>> map["maxY"]
    }
}

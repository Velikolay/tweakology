//
//  CGRect+Mappable.swift
//  TweakologyEngine
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
        minX >>> map["x"]
        minY >>> map["y"]
        width >>> map["width"]
        height >>> map["height"]
    }
}

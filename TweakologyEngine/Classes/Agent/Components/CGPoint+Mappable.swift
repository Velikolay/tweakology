//
//  CGPoint+Mappable.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 19.01.19.
//

import Foundation
import ObjectMapper

extension CGPoint: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        x >>> map["x"]
        y >>> map["y"]
    }
}

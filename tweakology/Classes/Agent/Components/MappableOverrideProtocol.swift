//
//  MappableView.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/17/18.
//

import Foundation
import ObjectMapper

public protocol MappableOverride {
    static func objectForMappingOverride(map: Map) -> BaseMappable?
    mutating func mappingOverride(map: Map)
}

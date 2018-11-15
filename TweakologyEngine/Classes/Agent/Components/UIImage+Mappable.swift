//
//  UIImage+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/11/18.
//

import Foundation
import ObjectMapper

extension UIImage: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        src >>> map["src"]
    }
}

//
//  UIColor.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/14/18.
//

import Foundation
import ObjectMapper

extension UIColor: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        cgColor.alpha >>> map["alpha"]
        if let components = cgColor.components {
            Array(components.prefix(cgColor.numberOfComponents - 1)) >>> map["components"]
            hexStringFromColor(cg: cgColor) >>> map["hexValue"]
        }
    }
}

func hexStringFromColor(cg: CGColor) -> String? {
    if cg.numberOfComponents == 4, let components = cg.components {
        let r = components[0]
        let g = components[1]
        let b = components[2]

        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255))).lowercased()
    }
    return nil
}

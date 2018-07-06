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
    var r, g, b: CGFloat
    if let components = cg.components {
        if cg.numberOfComponents == 4 {
            r = components[0]
            g = components[1]
            b = components[2]
        } else if cg.numberOfComponents == 2 {
            r = components[0]
            g = components[0]
            b = components[0]
        } else {
            return nil;
        }
    } else {
        return nil;
    }
    return String(format: "#%02lX%02lX%02lX",
                  lroundf(Float(r * 255)),
                  lroundf(Float(g * 255)),
                  lroundf(Float(b * 255))).lowercased()
}

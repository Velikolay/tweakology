//
//  Constraint.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 7/17/18.
//

import Foundation
import ObjectMapper

extension NSLayoutConstraint: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        isActive >>> map["isActive"]
        constant >>> map["constant"]
        multiplier >>> map["multiplier"]
        priority.rawValue >>> map["priority"]
        relation.rawValue >>> map["relation"]

        (firstItem as! UIView).uid >>> map["first.item"]
        firstAttribute.rawValue >>> map["first.attribute"]

        if let secondView = secondItem as? UIView {
            secondView.uid >>> map["second.item"]
            secondAttribute.rawValue >>> map["second.attribute"]
        }
    }
}

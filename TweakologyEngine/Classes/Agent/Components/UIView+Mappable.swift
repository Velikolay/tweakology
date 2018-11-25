//
//  UIView+Mappable.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/15/18.
//

import Foundation
import ObjectMapper

extension UIView: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        String(describing:type(of: self)) >>> map["type"]
        frame >>> map["properties.frame"]
        if backgroundColor != nil {
            backgroundColor >>> map["properties.backgroundColor"]
        } else {
            0 >>> map["properties.backgroundColor.alpha"]
            "#ffffff" >>> map["properties.backgroundColor.hexValue"]
        }
        contentMode.rawValue >>> map["properties.contentMode"]
        if #available(iOS 9.0, *) {
            semanticContentAttribute.rawValue >>> map["properties.semanticContentAttribute"]
        }
        if String(describing:type(of: self)) == "UIWindow" {
            generateUID() >>> map["uid.value"]
            UIViewIdentifierKind.generated >>> map["uid.kind"]
        } else {
            uid?.value >>> map["uid.value"]
            uid?.kind >>> map["uid.kind"]
        }

        if var mappableOverride = self as? MappableOverride {
            mappableOverride.mappingOverride(map: map)
        }
        constraintsState.filter({ (constraint: NSLayoutConstraint) -> Bool in
            (constraint.firstItem as? UIView) != nil && constraint.firstAttribute.rawValue <= 20 &&
            ((constraint.secondItem as? UIView) == nil || constraint.secondAttribute.rawValue <= 20)
        }) >>> map["constraints"]
        if !subviews.isEmpty {
            subviews >>> map["subviews"]
        }
    }
}

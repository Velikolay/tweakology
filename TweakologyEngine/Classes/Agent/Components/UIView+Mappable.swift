//
//  UIView+Mappable.swift
//  TweakologyEngine
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
        String(describing:type(of: self)) >>> map["name"]
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
        isHidden >>> map["properties.isHidden"]
//        hierarchyMetadata >>> map["hm"]
        uid?.value >>> map["uid.value"]
        uid?.kind >>> map["uid.kind"]

        if uid == nil {
            "None" >>> map["uid.value"]
            //            String("gen-\(generateUID())") >>> map["uid.value"]
            //            UIViewIdentifierKind.generated >>> map["uid.kind"]
        }

        applyMappingOverride(view: self, map: map)
        constraints.filter({ (constraint: NSLayoutConstraint) -> Bool in
            (constraint.firstItem as? UIView) != nil && constraint.firstAttribute.rawValue <= 20 &&
                ((constraint.secondItem as? UIView) == nil || constraint.secondAttribute.rawValue <= 20)
        }) >>> map["constraints"]
        if !subviews.isEmpty {
            subviews >>> map["subviews"]
        }
    }

    private func applyMappingOverride(view: UIView, map: Map) {
        if let mo = view as? UIWindow {
            "UIWindow" >>> map["type"]
            mo.mappingOverride(map: map)
        } else if let mo = view as? UILabel {
            "UILabel" >>> map["type"]
            mo.mappingOverride(map: map)
        } else if let mo = view as? UIButton {
            "UIButton" >>> map["type"]
            mo.mappingOverride(map: map)
        } else if let mo = view as? UIImageView {
            "UIImageView" >>> map["type"]
            mo.mappingOverride(map: map)
        } else if let mo = view as? UIScrollView {
            "UIScrollView" >>> map["type"]
            mo.mappingOverride(map: map)
        } else {
            "UIView" >>> map["type"]
        }
    }
}

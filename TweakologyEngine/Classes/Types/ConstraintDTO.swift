//
//  ConstraintDTO.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 8/4/18.
//

import Foundation
import ObjectMapper

let relations = [
    "<": -1,
    "=": 0,
    ">": 1
]

let attributes = [
    "noAttribute": 0,
    "left": 1,
    "right": 2,
    "top": 3,
    "bottom": 4,
    "leading": 5,
    "trailing": 6,
    "width": 7,
    "height": 8,
    "centerX": 9,
    "centerY": 10,
    "lastBaseline": 11,
    "firstBaseline": 12,
    "leftMargin": 13,
    "rightMargin": 14,
    "topMargin": 15,
    "bottomMargin": 16,
    "leadingMargin": 17,
    "trailingMargin": 18,
    "centerXWithinMargins": 19,
    "centerYWithinMargins": 20
]

class AnchorDTO: Mappable {
    var item: String!
    var attribute: AnyObject!

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        item <- map["item"]
        attribute <- map["attribute"]
    }
}

class MetadataDTO: Mappable {
    var added: Bool!

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        added <- map["added"]
    }
}

class ConstraintDTO: Mappable {
    var meta: MetadataDTO!
    var first: AnchorDTO!
    var second: AnchorDTO?
    var relation: AnyObject!
    var constant: Float?
    var multiplier: Float?
    var isActive: Bool!
    var priority: Float!
    var idx: Int!

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        meta <- map["meta"]
        first <- map["first"]
        second <- map["second"]
        relation <- map["relation"]
        constant <- map["constant"]
        multiplier <- map["multiplier"]
        isActive <- map["isActive"]
        priority <- map["priority"]
        idx <- map["idx"]
    }

    public func toNSLayoutConstraint(view: UIView) -> NSLayoutConstraint? {
        let fromView = viewItemFromUid(view: view, uid: first.item)
        let toView = viewItemFromUid(view: view, uid: second?.item)
        
        if let fromView = fromView,
            let fromAttribute = attributeFromDTO(attrConfig: first.attribute)
        {
            let relatedBy = relationFromDTO(relationConfig: relation) ?? .equal
            let toAttribute = attributeFromDTO(attrConfig: second?.attribute) ?? .notAnAttribute
            let constraint = NSLayoutConstraint(item: fromView, attribute: fromAttribute, relatedBy: relatedBy, toItem: toView, attribute: toAttribute, multiplier: CGFloat(multiplier ?? 1), constant: CGFloat(constant ?? 0))
            constraint.isActive = isActive
            constraint.priority = UILayoutPriority(rawValue: priority)
            constraint.meta = ConstraintMetadata(added: meta.added)
            return constraint
        }
        return nil
    }

    private func attributeFromDTO(attrConfig: AnyObject?) -> NSLayoutConstraint.Attribute? {
        if ((attrConfig as? String) != nil), let attr = attributes[attrConfig as! String] {
            return NSLayoutConstraint.Attribute(rawValue: attr)
        } else if let attr = attrConfig as? Int {
            return NSLayoutConstraint.Attribute(rawValue: attr)
        } else {
            return nil
        }
    }
    
    private func relationFromDTO(relationConfig: AnyObject) -> NSLayoutConstraint.Relation? {
        if ((relationConfig as? String) != nil), let relation = relations[relationConfig as! String] {
            return NSLayoutConstraint.Relation(rawValue: relation)
        } else if let relation = relationConfig as? Int {
            return NSLayoutConstraint.Relation(rawValue: relation)
        } else {
            return nil
        }
    }

    private func viewItemFromUid(view: UIView, uid: String?) -> UIView? {
        if let uid = uid {
            if view.uid?.value == uid {
                return view
            } else {
                for subview in view.subviews {
                    if subview.uid?.value == uid {
                        return subview
                    }
                }
            }
        }
        return nil
    }
}

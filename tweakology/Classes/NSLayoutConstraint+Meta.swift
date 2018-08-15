//
//  NSLayoutConstraint+Meta.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 8/15/18.
//

import Foundation

func associatedObject2<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject2<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

public class ConstraintMetadata {
    var added: Bool
    init(added: Bool = false) {
        self.added = added
    }
}

private var metaKey: UInt8 = 0

extension NSLayoutConstraint {

    public var meta: ConstraintMetadata {
        get {
            return associatedObject2(base: self, key: &metaKey)
            { return ConstraintMetadata() }
        }
        set { associateObject2(base: self, key: &metaKey, value: newValue) }
    }
}

//
//  UIView+ConstraintsState.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 8/14/18.
//

import Foundation

func associatedObjectArr<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> [ValueType])
    -> [ValueType] {
        if let associated = objc_getAssociatedObject(base, key)
            as? [ValueType] { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObjectArr<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: [ValueType]) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

private var constraintsStateKey: UInt8 = 1

extension UIView {

    public var constraintsState: [NSLayoutConstraint] {
        get {
            return associatedObjectArr(base: self, key: &constraintsStateKey)
            { return [NSLayoutConstraint]() }
        }
        set { associateObjectArr(base: self, key: &constraintsStateKey, value: newValue) }
    }
}

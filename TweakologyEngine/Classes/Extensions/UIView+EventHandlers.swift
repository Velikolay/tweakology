//
//  UIView+EventHandlers.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 19.01.20.
//

import Foundation

private var eventHandlersKey: UInt8 = 1

extension UIView {

    internal var eventHandlers: [String] {
        get {
            return objc_getAssociatedObject(self, &eventHandlersKey) as? [String] ?? []
        }
        set {
            objc_setAssociatedObject(self, &eventHandlersKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

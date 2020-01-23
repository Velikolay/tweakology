//
//  UIImage+Tweakology.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/11/18.
//

import Foundation

private var srcKey: UInt8 = 0

extension UIImage {
    
    var src: String {
        get {
            return objc_getAssociatedObject(self, &srcKey) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &srcKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

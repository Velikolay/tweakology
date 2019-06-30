//
//  UIView+RenderImage.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 4/1/18.
//

import Foundation

func associatedObject<ValueType: AnyObject>(
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

func associateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

private var imageKey: UInt8 = 0

extension UIView {

    public var renderedImage: UIImage {
        get {
            return associatedObject(base: self, key: &imageKey)
            { return UIImage() }
        }
        set { associateObject(base: self, key: &imageKey, value: newValue) }
    }

    public func recursiveRender() {
        self.nonRecursiveRender()

        for view in self.subviews {
            view.recursiveRender()
        }
    }

    public func nonRecursiveRender() {
        for view in self.subviews {
            view.isHidden = true
        }
        if let renderedImage = self.renderImage() {
            self.renderedImage = renderedImage
        }
        for view in self.subviews {
            view.isHidden = false
        }
    }

    public func renderImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            return renderer.image { rendererContext in
                self.layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

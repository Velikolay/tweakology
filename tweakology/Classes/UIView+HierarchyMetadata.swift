//
//  File.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 4/22/18.
//

import Foundation

extension UIView {
    
    var hierarchyMetadata: String {
        let className = String(describing:type(of: self))
        let parentVCClassName = (self.parentViewController != nil) ? String(describing:type(of: self.parentViewController!)): "none"

        if let parent = self.superview {
            let viewIndex = parent.subviews.index(of: self)
            return parent.hierarchyMetadata + "|" + className + ":" + String(describing: viewIndex!) + ":" + parentVCClassName
        } else {
            return className + ":0:" + parentVCClassName
        }
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

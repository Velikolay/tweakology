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
            let viewMetadata = className + ":" + String(describing: viewIndex!) + ":" + parentVCClassName
            if parent != UIApplication.shared.keyWindow {
                return parent.hierarchyMetadata + "|" + viewMetadata
            } else {
                return viewMetadata
            }
        } else {
            return className + ":0:" + parentVCClassName
        }
    }

    var uid: String? {
        guard let data = CryptoHash.sha1(hierarchyMetadata).data(using: String.Encoding.utf8) else {
            return nil
        }
        return String(data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)).prefix(10))
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

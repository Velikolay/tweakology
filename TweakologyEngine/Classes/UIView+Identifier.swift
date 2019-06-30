//
//  UIView+Identifier.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 4/22/18.
//

import Foundation

private var uidKey: UInt8 = 0

enum UIViewIdentifierKind: Int {
    case generated = 0
    case custom
}

public struct UIViewIdentifier {
    let value: String
    let kind: UIViewIdentifierKind
}

extension UIView {

    public var uid: UIViewIdentifier? {
        get {
            return objc_getAssociatedObject(self, &uidKey) as? UIViewIdentifier ?? nil
        }
        set {
            objc_setAssociatedObject(self, &uidKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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

    var hierarchyMetadata: String {
        let className = String(describing: type(of: self))
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

    func generateUID() -> String? {
        guard let data = CryptoHash.sha1(hierarchyMetadata).data(using: String.Encoding.utf8) else {
            return nil
        }
        return String(data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)).prefix(10))
    }
}

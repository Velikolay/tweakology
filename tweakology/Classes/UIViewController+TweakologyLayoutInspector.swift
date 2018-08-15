//
//  UIViewController+TweakologyLayoutInspectorProtocol.swift
//  Pods-tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit
import Foundation

public typealias ViewIndex = [String: UIView]

extension UIViewController: TweakologyLayoutInspectorProtocol {
    private func inspectLayout(view: UIView, viewIndex: inout ViewIndex) {
        let uid = view.uid!
        view.constraintsState = view.constraints.map { (constraint) -> NSLayoutConstraint in
            constraint
        }
        //                let viewType = self.typeNameOf(object: view)
        //                print(viewType, "view frame:", view.frame)
        if let uiLabel = view as? UILabel {
            viewIndex[uid] = uiLabel
            //                    print(viewType, "subview")
            //                    print(viewType, "constraints:", uiLabel.constraints)
            //                    print(viewType, "constraints:", uiLabel.superview!.constraints)
        } else if let uiButton = view as? UIButton {
            viewIndex[uid] = uiButton
            //                    print(viewType, "subview")
            //                    print(viewType, "constraints:", uiButton.constraints)
            //                    print(viewType, "constraints:", uiButton.superview!.constraints)
        } else if let uiImageView = view as? UIImageView {
            viewIndex[uid] = uiImageView
            //                    print(viewType, "subview")
            //                    print(viewType, "constraints:", uiButton.constraints)
            //                    print(viewType, "constraints:", uiButton.superview!.constraints)
        } else {
            // compound view
            viewIndex[uid] = view
            for subview in view.subviews {
                inspectLayout(view: subview, viewIndex: &viewIndex)
            }
        }
    }

    private func typeNameOf(object: Any) -> String {
        let thisType = type(of: object)
        return String(describing: thisType)
    }

    public func inspectLayout() -> ViewIndex {
        var viewIndex: ViewIndex = [:]
        self.inspectLayout(view: self.view, viewIndex: &viewIndex)
        return viewIndex
    }
}

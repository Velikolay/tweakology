//
//  UIViewController+TweakologyLayoutInspectorProtocol.swift
//  Pods-tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit
import Foundation

public typealias ViewIndex = [String: IndexedView]

extension UIViewController: TweakologyLayoutInspectorProtocol {
    private func inspectLayout(subviews: [UIView]?, viewIndex: inout ViewIndex) {
        if let subviewUnwrapped = subviews {
            for view in subviewUnwrapped {
                let uid = view.uid!
                //                let viewType = self.typeNameOf(object: view)
                //                print(viewType, "view frame:", view.frame)
                if let uiLabel = view as? UILabel {
                    viewIndex[uid] = IndexedView(id: uid, isTerminal: true, type: "UILabel", view: uiLabel)
                    //                    print(viewType, "subview")
                    //                    print(viewType, "constraints:", uiLabel.constraints)
                    //                    print(viewType, "constraints:", uiLabel.superview!.constraints)
                } else if let uiButton = view as? UIButton {
                    viewIndex[uid] = IndexedView(id: uid, isTerminal: true, type: "UIButton", view: uiButton)
                    //                    print(viewType, "subview")
                    //                    print(viewType, "constraints:", uiButton.constraints)
                    //                    print(viewType, "constraints:", uiButton.superview!.constraints)
                } else if let uiImageView = view as? UIImageView {
                    viewIndex[uid] = IndexedView(id: uid, isTerminal: true, type: "UIImageView", view: uiImageView)
                    //                    print(viewType, "subview")
                    //                    print(viewType, "constraints:", uiButton.constraints)
                    //                    print(viewType, "constraints:", uiButton.superview!.constraints)
                } else {
                    // compound view
                    viewIndex[uid] = IndexedView(id: uid, isTerminal: false, type: "UIView", view: view)
                    inspectLayout(subviews: view.subviews, viewIndex: &viewIndex)
                }
            }
        }
    }

    private func typeNameOf(object: Any) -> String {
        let thisType = type(of: object)
        return String(describing: thisType)
    }
    
    public func inspectLayout() -> ViewIndex {
        var viewIndex: ViewIndex = [:]
        self.inspectLayout(subviews: self.view.subviews, viewIndex: &viewIndex)
        return viewIndex
    }
}

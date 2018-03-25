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
    private func inspectLayout(subviews: [UIView]?, parentId: Int, viewIndex: inout ViewIndex) {
        if let subviewUnwrapped = subviews {
            var viewId = parentId
            for view in subviewUnwrapped {
                viewId += 1
                //                let viewType = self.typeNameOf(object: view)
                //                print(viewType, "view frame:", view.frame)
                if let uiLabel = view as? UILabel {
                    viewIndex[String(viewId)] = IndexedView(id: String(viewId), parentId: String(parentId), isTerminal: true, type: "UILabel", view: uiLabel)
                    //                    print(viewType, "subview")
                    //                    print(viewType, "constraints:", uiLabel.constraints)
                    //                    print(viewType, "constraints:", uiLabel.superview!.constraints)
                } else if let uiButton = view as? UIButton {
                    viewIndex[String(viewId)] = IndexedView(id: String(viewId), parentId: String(parentId), isTerminal: true, type: "UIButton", view: uiButton)
                    //                    print(viewType, "subview")
                    //                    print(viewType, "constraints:", uiButton.constraints)
                    //                    print(viewType, "constraints:", uiButton.superview!.constraints)
                } else {
                    // compound view
                    viewIndex[String(viewId)] = IndexedView(id: String(viewId), parentId: String(parentId), isTerminal: false, type: "UIView", view: view)
                    inspectLayout(subviews: view.subviews, parentId: viewId, viewIndex: &viewIndex)
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
        self.inspectLayout(subviews: self.view.subviews, parentId: -1, viewIndex: &viewIndex)
        return viewIndex
    }
}

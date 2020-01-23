//
//  UIViewController+TweakologyLayoutInspectorProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit
import Foundation

public typealias ViewIndex = [String: UIView]

extension UIViewController: TweakologyLayoutInspectorProtocol {
    @nonobjc private func inspectLayout(view: UIView, viewIndex: inout ViewIndex) {
        if view.uid == nil, let generatedUid = view.generateUID() {
            view.uid = UIViewIdentifier(value: generatedUid, kind: .generated)
        }
        if let uid = view.uid?.value {
            view.constraintsState = view.constraints.map { (constraint) -> NSLayoutConstraint in
                constraint
            }
            viewIndex[uid] = view
            if let uiButton = view as? UIButton, let uiButtonLabel = uiButton.titleLabel {
                inspectLayout(view: uiButtonLabel, viewIndex: &viewIndex)
            }
            for subview in view.subviews {
                inspectLayout(view: subview, viewIndex: &viewIndex)
            }
        }
    }

    private func typeNameOf(object: Any) -> String {
        let thisType = type(of: object)
        return String(describing: thisType)
    }

    func inspectLayout() -> ViewIndex {
        var viewIndex: ViewIndex = [:]
        self.inspectLayout(view: self.view, viewIndex: &viewIndex)
        return viewIndex
    }
}

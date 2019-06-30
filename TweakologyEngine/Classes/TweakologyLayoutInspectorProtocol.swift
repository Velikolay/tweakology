//
//  TweakologyLayoutInspectorProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit

public protocol TweakologyLayoutInspectorProtocol {
    func inspectLayout() -> [String: UIView]
}

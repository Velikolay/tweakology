//
//  TweakologyLayoutInspectorProtocol.swift
//  Pods-tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit

public struct IndexedView {
    var id: String
    var isTerminal: Bool
    var type: String
    public var view: UIView
}

public protocol TweakologyLayoutInspectorProtocol {
    func inspectLayout() -> [String: IndexedView]
}

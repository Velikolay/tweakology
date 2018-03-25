//
//  TweaksLayoutInspectorProtocol.swift
//  TweaksDemo
//
//  Created by Nikolay Ivanov on 3/13/18.
//  Copyright © 2018 Nikolay Ivanov. All rights reserved.
//

import Foundation
import UIKit

struct IndexedView {
    var id: String
    var parentId: String
    var isTerminal: Bool
    var type: String
    var view: UIView
}

protocol TweaksLayoutInspectorProtocol {
    func inspectLayout() -> [String: IndexedView]
}

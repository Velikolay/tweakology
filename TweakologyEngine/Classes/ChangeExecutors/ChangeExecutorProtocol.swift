//
//  Executor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

protocol ChangeExecutorProtocol {
    func execute(_ config: [String: Any], view: UIView) -> Bool
}

//
//  ExpressionProcessorProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.07.19.
//

import Foundation

protocol ExpressionProcessor {
    func process(expression: String, context: [String: Any]) -> String?
}

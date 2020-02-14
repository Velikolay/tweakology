//
//  LiquidExpressionProcessor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.07.19.
//

import Foundation

class LiquidExpressionProcessor: ExpressionProcessor {
    func process(expression: String, context: [String: Any]) -> String? {
        let lexer = Lexer(templateString: expression)
        let tokens = lexer.tokenize().map { (token) -> Token in
            if case .text(let value) = token {
                return .text(value: value.trimmingCharacters(in: .newlines))
            }
            return token
        }
        let parser = Parser(tokens: tokens, context: Context(dictionary: context))
        let exprValues = parser.parse()
        return exprValues.joined(separator: "")
    }
}

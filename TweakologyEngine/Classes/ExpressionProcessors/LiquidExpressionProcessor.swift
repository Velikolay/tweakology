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
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens, context: Context(dictionary: context))
        let exprValues = parser.parse()
        return exprValues.count > 0 ? exprValues[0] : nil
    }
}

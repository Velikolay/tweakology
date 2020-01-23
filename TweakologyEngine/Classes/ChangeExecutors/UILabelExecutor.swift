//
//  UILabelExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UILabelExecutor: UIViewExecutor {
    override func execute(_ config: [String : Any], view: UIView) -> Bool {
        if let uilabel = view as? UILabel {
            super.execute(config, view: view)

            if let properties = config["properties"] as? [String: Any] {
                if let text = properties["text"] as? String {
                    uilabel.text = text
                }

                if let textColorConfig = properties["textColor"] as? [String: Any],
                    let uicolor = toUIColor(colorValue: textColorConfig["hexValue"] as! String)?.withAlphaComponent(textColorConfig["alpha"] as! CGFloat) {
                    uilabel.textColor = uicolor
                } else if let textColor = properties["textColor"] as? String {
                    uilabel.textColor = toUIColor(colorValue: textColor)
                }

                if let fontConfig = properties["font"] as? [String: Any],
                    let font = font(from: fontConfig) {
                    uilabel.font = font
                }

                if let rawValue = properties["textAlignment"] as? Int,
                    let alignment = NSTextAlignment(rawValue: rawValue) {
                    uilabel.textAlignment = alignment
                }

                if let rawValue = properties["lineBreakMode"] as? Int,
                    let lineBreak = NSLineBreakMode(rawValue: rawValue) {
                        uilabel.lineBreakMode = lineBreak
                }

                if let numberOfLines = properties["numberOfLines"] as? Int {
                    uilabel.numberOfLines = numberOfLines
                }
            }
            return true
        }
        return false
    }
}

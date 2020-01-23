//
//  UIButtonExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 21.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UIButtonExecutor: UIViewExecutor {
    override func execute(_ config: [String : Any], view: UIView) -> Bool {
        if let uibutton = view as? UIButton {
            super.execute(config, view: view)
 
            if let properties = config["properties"] as? [String: Any] {
                if let titleConfig = properties["title"] as? [String: Any] {
                    if let text = titleConfig["text"] as? String {
                        uibutton.setTitle(text, for: UIControl.State.normal)
                    }

                    if let rawValue = titleConfig["textAlignment"] as? Int,
                        let alignment = NSTextAlignment(rawValue: rawValue) {
                        uibutton.titleLabel?.textAlignment = alignment
                    }

                    if let textColorConfig = titleConfig["textColor"] as? [String: Any],
                        let uicolor = toUIColor(colorValue: textColorConfig["hexValue"] as! String)?.withAlphaComponent(textColorConfig["alpha"] as! CGFloat) {
                        uibutton.setTitleColor(uicolor, for:  UIControl.State.normal)
                    } else if let textColor = titleConfig["textColor"] as? String {
                        let color = toUIColor(colorValue: textColor)
                        uibutton.setTitleColor(color, for:  UIControl.State.normal)
                    }

                    if let fontConfig = titleConfig["font"] as? [String: Any],
                        let font = font(from: fontConfig) {
                        uibutton.titleLabel?.font = font
                    }

                    if let rawValue = titleConfig["lineBreakMode"] as? Int,
                        let lineBreak = NSLineBreakMode(rawValue: rawValue) {
                        uibutton.titleLabel?.lineBreakMode = lineBreak
                    }

                    if let numberOfLines = titleConfig["numberOfLines"] as? Int {
                        uibutton.titleLabel?.numberOfLines = numberOfLines
                    }
                }
            }
            return true
        }
        return false
    }
}

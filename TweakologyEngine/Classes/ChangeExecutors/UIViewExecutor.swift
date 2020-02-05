//
//  UIViewExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UIViewExecutor: NSObject, ChangeExecutorProtocol {
    let context: EngineContext

    init(_ context: EngineContext) {
        self.context = context
    }

    private func cgFloatFrom(_ value: Any?,_ defaultValue: CGFloat) -> CGFloat {
        if let value = value as? Double {
            return CGFloat(value)
        }
        return defaultValue
    }

    func execute(_ config: [String : Any], view: UIView) -> Bool {
        if let frame = config["frame"] as? [String: Any] {
            view.frame = CGRect(x: cgFloatFrom(frame["x"], view.frame.origin.x), y: cgFloatFrom(frame["y"], view.frame.origin.y), width: cgFloatFrom(frame["width"], view.frame.size.width), height: cgFloatFrom(frame["height"], view.frame.size.height))
            setFrame(frame, view: view)
        }

        if let properties = config["properties"] as? [String: Any] {
            if let backgroundColorConfig = properties["backgroundColor"] as? [String: Any],
                let uicolor = toUIColor(colorValue: backgroundColorConfig["hexValue"] as! String)?.withAlphaComponent(backgroundColorConfig["alpha"] as! CGFloat) {
                view.backgroundColor = uicolor
            } else if let backgroundColor = config["backgroundColor"] as? String {
                view.backgroundColor = toUIColor(colorValue: backgroundColor)
            }

            if let rawValue = properties["contentMode"] as? Int,
                let contentMode = UIView.ContentMode(rawValue: rawValue) {
                view.contentMode = contentMode
            }

            if let rawValue = properties["semanticContentAttribute"] as? Int,
                let semantic = UISemanticContentAttribute(rawValue: rawValue) {
                view.semanticContentAttribute = semantic
            }
        }
        
        if let layerConfig = config["layer"] as? [String: Any] {
            self.setLayer(layerConfig, view: view)
        }
        
        if let constraintsConfig = config["constraints"] as? [[String: Any]] {
            self.setConstraints(constraintsConfig, view: view)
        }
        
        return true
    }

    private func setConstraints(_ constraintsConfig: [[String: Any]], view: UIView) {
        let dtos = constraintsConfig.map({ (config) -> ConstraintDTO? in
            ConstraintDTO(JSON: config)
        })
        for dto in dtos {
            if let dto = dto {
                if dto.idx < view.constraintsState.count {
                    let toModify = view.constraintsState[dto.idx]
                    toModify.constant = CGFloat(dto.constant ?? 0)
                    toModify.isActive = dto.isActive
                    toModify.priority = UILayoutPriority(rawValue: dto.priority)
                } else {
                    if let constraint = dto.toNSLayoutConstraint(view: view) {
                        view.constraintsState.append(constraint)
                    }
                }
            }
        }
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
    }
    
    private func setFrame(_ frameConfig: [String: Any], view: UIView) {
        var x = view.frame.origin.x
        var y = view.frame.origin.y
        var height = view.frame.height
        var width = view.frame.width
        
        for (attr, val) in frameConfig {
            var propVal: CGFloat
            if let expr = val as? String {
                let tokens = parseExpression(expr: expr)
                let secondViewId = tokens[0]
                var secondViewAttribute = tokens[1]

                if secondViewAttribute.isEmpty {
                    secondViewAttribute = attr
                }

                guard let constant = NumberFormatter().number(from: tokens[2]) else { return }
                propVal = CGFloat(truncating: constant)

                if !secondViewId.isEmpty {
                    if let secondView = self.viewWith(id: secondViewId, view: view) {
                        if let secondViewPropVal = self.frameValue(frame: secondView.frame, property: secondViewAttribute) {
                            propVal += secondViewPropVal
                        }
                    }
                }
            } else {
                propVal = val as! CGFloat
            }

            if attr == "height" {
                height = propVal
            } else if attr == "width" {
                width = propVal
            } else if attr == "x" {
                x = propVal
            } else if attr == "y" {
                y = propVal
            }
        }
        view.frame = CGRect(x: x, y: y, width: width, height: height)
    }

    private func viewWith(id: String, view: UIView) -> UIView? {
        if id == "self" {
            return view
        } else if id == "superview" {
            return view.superview
        } else {
            return self.context.viewIndex[id]
        }
    }

    private func frameValue(frame: CGRect, property: String) -> CGFloat? {
        if property == "height" {
            return frame.height
        } else if property == "width" {
            return frame.width
        } else if property == "x" {
            return frame.origin.x
        } else if property == "y" {
            return frame.origin.y
        }
        return nil
    }

    private func setLayer(_ layerConfig: [String: Any], view: UIView) {
        let layer = view.layer
        for (key, val) in layerConfig {
            if let valStr = val as? String {
                if (layer.value(forKey: key) as? UIColor) != nil {
                    if let color = toUIColor(colorValue: valStr) {
                        layer.setValue(color, forKey: key)
                    }
                } else if(CFGetTypeID(layer.value(forKey: key) as CFTypeRef) == CGColor.typeID) {
                    if let color = toUIColor(colorValue: valStr) {
                        layer.setValue(color.cgColor, forKey: key)
                    }
                } else {
                    layer.setValue(valStr, forKey: key)
                }
            } else if let valDouble = val as? Double {
                layer.setValue(CGFloat(valDouble), forKey: key)
            } else if let valInt = val as? Int {
                layer.setValue(CGFloat(valInt), forKey: key)
            } else if let valBool = val as? Bool {
                layer.setValue(valBool, forKey: key)
            }
        }
    }
}

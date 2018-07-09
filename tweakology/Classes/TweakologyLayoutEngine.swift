//
//  TweakologyLayoutEngine.swift
//  Pods-tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit
import Foundation

@available(iOS 10.0, *)
public class TweakologyLayoutEngine {
    
    public static let sharedInstance = TweakologyLayoutEngine()
    private var viewIndex: ViewIndex

    private init() {
        self.viewIndex = [:]
    }

    public func updateViewIndex(viewIndex: ViewIndex) {
        self.viewIndex = viewIndex
    }

    public func tweak(changeSeq: [[String: Any]]) {
        for change in changeSeq {
            switch change["operation"] as! String {
            case "insert":
                print("Insert operation")
                self.handleUIViewInsert(change: change)
            case "modify":
                print("Modify operation")
                self.handleUIViewModify(change: change)
            default:
                print("Unsupported operation")
            }
        }
    }

    private func handleUIViewInsert(change: [String: Any]) {
        let viewConfig = dictVal(dict: change, key: "view")
        let superviewId = strVal(dict: viewConfig, key: "superview")
        if let superview = self.viewIndex[superviewId] {
            let viewId = strVal(dict: viewConfig, key: "id")
            let viewType = strVal(dict: viewConfig, key: "type")
            let view = self.createUIViewObject(viewConfig: viewConfig)
            superview.view.insertSubview(view, at: intVal(dict: viewConfig, key: "index"))
            self.setUIViewObjectConstraints(viewConfig: viewConfig, view: view, modify: false)
            self.viewIndex[viewId] = IndexedView(id: viewId, isTerminal: true, type: viewType, view: view)
        }
    }

    private func handleUIViewModify(change: [String: Any]) {
        let viewConfig = dictVal(dict: change, key: "view")
        let viewId = strVal(dict: viewConfig, key: "id")
        if let modifiedView = self.viewIndex[viewId]?.view {
            if let props = dictValOpt(dict: viewConfig, key: "properties") {
                self.setViewProperties(view: modifiedView, propertiesConfig: props)
            }
            if let layer = dictValOpt(dict: viewConfig, key: "layer") {
                self.setViewLayer(view: modifiedView, layerConfig: layer)
            }
            
            self.setUIViewObjectConstraints(viewConfig: viewConfig, view: modifiedView, modify: true)
            self.setUIViewObjectFrame(viewConfig: viewConfig, view: modifiedView)
        }
    }

    private func createUIViewObject(viewConfig: [String: Any]) -> UIView {
        let viewType = strVal(dict: viewConfig, key: "type")
        let myclass = stringClassFromString(viewType) as! UIView.Type
        let instance = myclass.init()
        if let frame = viewConfig["frame"] as? [String: Int] {
            instance.frame = CGRect(x: frame["x"]!, y: frame["y"]!, width: frame["width"]!, height: frame["height"]!)
        }
        
        if let props = dictValOpt(dict: viewConfig, key: "properties") {
            self.setViewProperties(view: instance, propertiesConfig: props)
        }
        if let layer = dictValOpt(dict: viewConfig, key: "layer") {
            self.setViewLayer(view: instance, layerConfig: layer)
        }
        return instance
    }

    private func setViewProperties(view: UIView, propertiesConfig: [String: Any]) {
        for (key, val) in propertiesConfig {
            if !self.setUILabelSpecificProperty(view: view, key: key, value: val),
                !self.setUIButtonSpecificProperty(view: view, key: key, value: val) {
                if let valStr = val as? String {
                    if (view.value(forKey: key) as? UIColor) != nil {
                        if let color = toUIColor(colorValue: valStr) {
                            view.setValue(color, forKey: key)
                        }
                    } else if(CFGetTypeID(view.value(forKey: key) as CFTypeRef) == CGColor.typeID) {
                        if let color = toUIColor(colorValue: valStr) {
                            view.setValue(color.cgColor, forKey: key)
                        }
                    } else {
                        view.setValue(valStr, forKey: key)
                    }
                } else if let valDouble = val as? Double {
                    view.setValue(CGFloat(valDouble), forKey: key)
                } else if let valInt = val as? Int {
                    view.setValue(CGFloat(valInt), forKey: key)
                } else if let valBool = val as? Bool {
                    view.setValue(valBool, forKey: key)
                } else if let valDict = val as? [String: Any] {
                    if (view.value(forKey: key) as? UIColor) != nil {
                        if let color = toUIColor(colorValue: valDict["hexValue"] as! String)?.withAlphaComponent(valDict["alpha"] as! CGFloat) {
                            view.setValue(color, forKey: key)
                        }
                    } else if(CFGetTypeID(view.value(forKey: key) as CFTypeRef) == CGColor.typeID) {
                        if let color = toUIColor(colorValue: valDict["hexValue"] as! String)?.withAlphaComponent(valDict["alpha"] as! CGFloat) {
                            view.setValue(color.cgColor, forKey: key)
                        }
                    } else if (view.value(forKey: key) as? UIFont) != nil,
                        let font = font(from: valDict) {
                        view.setValue(font, forKey: key)
                    }
                }
            }
        }
    }

    private func setUILabelSpecificProperty(view: UIView, key: String, value: Any) -> Bool {
        if let labelView = view as? UILabel {
            if key == "textAlignment", let alignment = toNSTextAlignment(alignment: value as! String) {
                labelView.textAlignment = alignment
                return true
            }
        }
        return false
    }

    private func setUIButtonSpecificProperty(view: UIView, key: String, value: Any) -> Bool {
        if let buttonView = view as? UIButton {
            if key == "title" {
                if let buttonTitle = value as? [String: Any] {
                    for (titleKey, titleVal) in buttonTitle {
                        if titleKey == "text" {
                            buttonView.setTitle(titleVal as? String, for: UIControlState.normal)
                        } else if titleKey == "textColor" {
                            if let textColor = titleVal as? [String: Any],
                                let color = toUIColor(colorValue: textColor["hexValue"] as! String)?.withAlphaComponent(textColor["alpha"] as! CGFloat) {
                                buttonView.setTitleColor(color, for:  UIControlState.normal)
                            } else if let textColor = titleVal as? String {
                                let color = toUIColor(colorValue: textColor)
                                buttonView.setTitleColor(color, for:  UIControlState.normal)
                            }
                        } else if titleKey == "font",
                            let titleFont = titleVal as? [String: Any],
                            let font = font(from: titleFont) {
                            buttonView.titleLabel?.font = font
                        }
                    }
                }
                return true
            }
        }
        return false
    }

    private func setViewLayer(view: UIView, layerConfig: [String: Any]) {
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

    private func setUIViewObjectConstraints(viewConfig: [String: Any], view: UIView, modify: Bool) {
        if let constraints = viewConfig["constraints"] as? [String: String] {
            view.translatesAutoresizingMaskIntoConstraints = false

            for (attr, val) in constraints {
                let tokens = parseExpression(expr: val)
                let secondViewId = tokens[0]
                var secondViewAttribute = tokens[1]
                if secondViewAttribute.isEmpty {
                    secondViewAttribute = attr
                }
                guard let constant = NumberFormatter().number(from: tokens[2]) else { return }

                if secondViewId.isEmpty {
                    if let layoutAttribute = view.value(forKey: attr) as? NSLayoutDimension {
                        if (modify) {
                            if let constraint = view.constraints.filter({ $0.firstAnchor == layoutAttribute }).first { // assuming it's only one
                                constraint.isActive = false
                            }
                        }
                        layoutAttribute.constraint(equalToConstant: CGFloat(truncating: constant)).isActive = true
                    }
                } else {
                    if let secondView = self.viewWith(id: secondViewId, view: view) {
                        if let layoutAttribute = view.value(forKey: attr) as? NSLayoutAnchor<NSLayoutXAxisAnchor> {
                            let relativeAnchor = secondView.value(forKey: secondViewAttribute) as! NSLayoutAnchor<NSLayoutXAxisAnchor>
                            if (modify) {
                                if let constraint = view.superview!.constraints.filter({ $0.firstAnchor == layoutAttribute }).first { // assuming it's only one
                                    constraint.isActive = false
                                }
                            }
                            layoutAttribute.constraint(equalTo: relativeAnchor, constant: CGFloat(truncating: constant)).isActive = true
                        }
                        
                        if let layoutAttribute = view.value(forKey: attr) as? NSLayoutAnchor<NSLayoutYAxisAnchor> {
                            let relativeAnchor = secondView.value(forKey: secondViewAttribute) as! NSLayoutAnchor<NSLayoutYAxisAnchor>
                            if (modify) {
                                if let constraint = view.superview!.constraints.filter({ $0.firstAnchor == layoutAttribute }).first { // assuming it's only one
                                    constraint.isActive = false
                                }
                            }
                            layoutAttribute.constraint(equalTo: relativeAnchor, constant: CGFloat(truncating: constant)).isActive = true
                        }
                    }
                }
            }
        }
    }
    
    private func viewWith(id: String, view: UIView) -> UIView? {
        if id == "self" {
            return view
        } else if id == "superview" {
            return view.superview
        } else {
            return self.viewIndex[id]?.view
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

    private func setUIViewObjectFrame(viewConfig: [String: Any], view: UIView) {
        if let frameConfig = viewConfig["frame"] as? [String: Any] {
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
    }
}

func parseExpression(expr: String) -> [String] {
    do {
        let viewMatcher = "self|superview|[A-Za-z0-9+/=]+"
        let secondViewOffsetRegex = try NSRegularExpression(pattern: "^\\$\\((\(viewMatcher))\\) ([+-]) ([1-9][0-9]*)$")
        let secondViewOffsetResults = secondViewOffsetRegex.matches(in: expr,
                                                                        range: NSRange(expr.startIndex..., in: expr))
        if secondViewOffsetResults.count > 0 {
            let sign = String(expr[Range(secondViewOffsetResults[0].range(at: 2), in: expr)!])
            var constant = String(expr[Range(secondViewOffsetResults[0].range(at: 3), in: expr)!])
            if (sign == "-") {
                constant = "-" + constant
            }
            return [String(expr[Range(secondViewOffsetResults[0].range(at: 1), in: expr)!]), "", constant]
        }
        
        let secondViewAnchorOffsetRegex = try NSRegularExpression(pattern: "^\\$\\((\(viewMatcher))\\)\\.([A-z]+) ([+-]) ([1-9][0-9]*)$")
        let secondViewAnchorOffsetResults = secondViewAnchorOffsetRegex.matches(in: expr,
                                                                                    range: NSRange(expr.startIndex..., in: expr))
        if secondViewAnchorOffsetResults.count > 0 {
            let sign = String(expr[Range(secondViewAnchorOffsetResults[0].range(at: 3), in: expr)!])
            var constant = String(expr[Range(secondViewAnchorOffsetResults[0].range(at: 4), in: expr)!])
            if (sign == "-") {
                constant = "-" + constant
            }
            return [String(expr[Range(secondViewAnchorOffsetResults[0].range(at: 1), in: expr)!]), String(expr[Range(secondViewAnchorOffsetResults[0].range(at: 2), in: expr)!]), constant]
        }
        
        let secondViewNoOffsetRegex = try NSRegularExpression(pattern: "^\\$\\((\(viewMatcher))\\)$")
        let secondViewNoOffsetResult = secondViewNoOffsetRegex.matches(in: expr,
                                                                           range: NSRange(expr.startIndex..., in: expr))
        if secondViewNoOffsetResult.count > 0 {
            return [String(expr[Range(secondViewNoOffsetResult[0].range(at: 1), in: expr)!]), "", "0"]
        }
        
        let secondViewAnchorNoOffsetRegex = try NSRegularExpression(pattern: "^\\$\\((\(viewMatcher))\\)\\.([A-z]+)$")
        let secondViewAnchorNoOffsetResult = secondViewAnchorNoOffsetRegex.matches(in: expr,
                                                                                       range: NSRange(expr.startIndex..., in: expr))
        if secondViewAnchorNoOffsetResult.count > 0 {
            return [String(expr[Range(secondViewAnchorNoOffsetResult[0].range(at: 1), in: expr)!]), String(expr[Range(secondViewAnchorNoOffsetResult[0].range(at: 2), in: expr)!]), "0"]
        }

        return ["", "", expr]
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func stringClassFromString(_ className: String) -> AnyClass! {
    /// get namespace
    _ = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    
    /// get 'anyClass' with classname and namespace
    let cls: AnyClass = NSClassFromString("\(className)")!
    
    // return AnyClass!
    return cls
}

func toUIColor(colorValue: String) -> UIColor? {
    let hexColorPattern = "^#([0-9a-f]{6})$"
    if colorValue.range(of: hexColorPattern, options: .regularExpression, range: nil, locale: nil) != nil {
        return colorFromHex(hexColor: colorValue)
    } else if colorValue == "black" {
        return UIColor.black
    } else if colorValue == "white" {
        return UIColor.white
    } else if colorValue == "green" {
        return UIColor.green
    } else if colorValue == "brown" {
        return UIColor.brown
    } else if colorValue == "blue" {
        return UIColor.blue
    }  else if colorValue == "red" {
        return UIColor.red
    }
    return nil
}

@available(iOS 8.2, *)
func font(from: [String: Any]) -> UIFont? {
    var font = systemFont(from: from)
    if font == nil {
        font = UIFont(name: from["fontName"] as! String, size: from["pointSize"] as! CGFloat)
    }
    return font
}

@available(iOS 8.2, *)
func systemFont(from: [String: Any]) -> UIFont? {
    if let familyName = from["familyName"] as? String,
        let fontStyle = from["fontStyle"] as? String,
        let pointSize = from["pointSize"] as? CGFloat {
        if familyName == "System", let weight = systemFontWeight(from: fontStyle) {
            return UIFont.systemFont(ofSize: pointSize, weight: weight)
        } else if familyName == "System Italic" {
            return UIFont.italicSystemFont(ofSize: pointSize)
        } else if familyName == "Text Style", let textStyle = textStyle(from: fontStyle) {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
    }
    return nil
}

func textStyle(from: String) -> UIFontTextStyle? {
    switch from {
        case "Body":
            return UIFontTextStyle.body
        case "Caption1":
            return UIFontTextStyle.caption1
        case "Caption2":
            return UIFontTextStyle.caption2
        case "Footnote":
            return UIFontTextStyle.footnote
        case "Headline":
            return UIFontTextStyle.headline
        case "Subheadline":
            return UIFontTextStyle.subheadline
        case "Title1":
            if #available(iOS 9.0, *) {
                return UIFontTextStyle.title1
            }
        case "Title2":
            if #available(iOS 9.0, *) {
                return UIFontTextStyle.title2
            }
        case "Title3":
            if #available(iOS 9.0, *) {
                return UIFontTextStyle.title3
            }
        case "Callout":
            if #available(iOS 9.0, *) {
                return UIFontTextStyle.callout
            }
        case "LargeTitle":
            if #available(iOS 11.0, *) {
                return UIFontTextStyle.largeTitle
            }
        default:
            return nil
    }
    return nil
}

@available(iOS 8.2, *)
func systemFontWeight(from: String) -> UIFont.Weight? {
    switch from {
        case "Bold":
            return UIFont.Weight.bold
        case "Semibold":
            return UIFont.Weight.semibold
        case "Medium":
            return UIFont.Weight.medium
        case "Light":
            return UIFont.Weight.light
        case "Thin":
            return UIFont.Weight.thin
        case "Heavy":
            return UIFont.Weight.heavy
        case "Black":
            return UIFont.Weight.black
        case "UltraLight":
            return UIFont.Weight.ultraLight
        case "Regular":
            return UIFont.Weight.regular
        default:
            return nil
    }
}

func colorFromHex(hexColor: String) -> UIColor {
    let hex = hexColor.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
        return .clear
    }
    return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
}

func toNSTextAlignment(alignment: String) -> NSTextAlignment? {
    if alignment == "center" {
        return NSTextAlignment.center
    } else if alignment == "left" {
        return NSTextAlignment.left
    } else if alignment == "right" {
        return NSTextAlignment.right
    } else if alignment == "justified" {
        return NSTextAlignment.justified
    } else if alignment == "natural" {
        return NSTextAlignment.natural
    }
    return nil
}

func intVal(dict: [String: Any], key: String) -> Int {
    return dict[key] as! Int
}

func strVal(dict: [String: Any], key: String) -> String {
    return dict[key] as! String
}

func dictVal(dict: [String: Any], key: String) -> [String: Any] {
    return dict[key] as! [String: Any]
}

func dictValOpt(dict: [String: Any], key: String) -> [String: Any]? {
    return dict[key] as? [String: Any]
}

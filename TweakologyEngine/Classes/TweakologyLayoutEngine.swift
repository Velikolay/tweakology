//
//  TweakologyLayoutEngine.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 3/25/18.
//

import UIKit
import Foundation
import SDWebImage

enum EngineMode {
    case development
    case production
}

@available(iOS 10.0, *)
class EngineContext {
    var viewIndex: [String: UIView]
    var eventHandlerIndex: [String: EventHandler]
    var actionIndex: [String: Action]
    let mode: EngineMode

    init(mode: EngineMode) {
        self.viewIndex = [:]
        self.actionIndex = [:]
        self.eventHandlerIndex = [:]
        self.mode = mode
    }
}

@available(iOS 10.0, *)
@objc public class TweakologyLayoutEngine: NSObject {
    public static let sharedInstance = TweakologyLayoutEngine()

    let context: EngineContext
    private let attributeStore: AttributeStore
    private let changeExecutor: ChangeExecutor

    override init() {
        for viewClass in SwizzlingClassProvider.sharedInstance.uiViewClasses {
            viewClass.swizzleDidAddSubview()
        }

        self.context = EngineContext(mode: EngineMode.development)
        self.changeExecutor = ChangeExecutor(self.context)
        self.attributeStore = InMemoryAttributeStore.sharedInstance
    }

    public func tweak(changeSeq: [[String: Any]]) {
        self.handleChanges(changeSeq: changeSeq, resource: "action", insertFunc: self.handleActionInsert, modifyFunc: self.handleActionModify)
        self.handleChanges(changeSeq: changeSeq, resource: "eventHandler", insertFunc: self.handleEventHandlerInsert, modifyFunc: self.handleEventHandlerModify)
        self.handleChanges(changeSeq: changeSeq, resource: "view", insertFunc: self.handleUIViewInsert, modifyFunc: self.handleUIViewModify)
    }

    private func handleChanges(changeSeq: [[String: Any]], resource: String, insertFunc: ([String: Any]) -> Void, modifyFunc: ([String: Any]) -> Void) {
        for change in changeSeq {
            if let config = change[resource] as? [String: Any],
                let operation = change["operation"] as? String {
                switch operation {
                    case "insert":
                        print("Operation: Insert \(resource)")
                        insertFunc(config)
                    case "modify":
                        print("Operation: Modify \(resource)")
                        modifyFunc(config)
                    default:
                        print("Unsupported operation")
                }
            }
        }
    }

    private func handleActionInsert(_ actionConfig: [String: Any]) {
        if let action = ActionDTO(JSON: actionConfig)?.toAction(actionFactory: ActionFactory.sharedInstance),
            self.context.actionIndex[action.getId()] == nil {
            self.context.actionIndex[action.getId()] = action
        }
    }

    private func handleActionModify(_ actionConfig: [String: Any]) {
        if let action = ActionDTO(JSON: actionConfig)?.toAction(actionFactory: ActionFactory.sharedInstance) {
            self.context.actionIndex[action.getId()] = action
        }
    }

    private func handleEventHandlerInsert(_ eventHandlerConfig: [String: Any]) {
        if let eventHandler = EventHandlerDTO(JSON: eventHandlerConfig)?.toEventHandler(context: self.context),
            self.context.eventHandlerIndex[eventHandler.getId()] == nil {
            self.context.eventHandlerIndex[eventHandler.getId()] = eventHandler
        }
    }

    private func handleEventHandlerModify(_ eventHandlerConfig: [String: Any]) {
        if let eventHandler = EventHandlerDTO(JSON: eventHandlerConfig)?.toEventHandler(context: self.context) {
            self.context.eventHandlerIndex[eventHandler.getId()] = eventHandler
        }
    }

    private func handleUIViewInsert(_ viewConfig: [String: Any]) {
        if let superviewId = viewConfig["superviewId"] as? String,
            let superview = self.context.viewIndex[superviewId],
            let viewId = viewConfig["id"] as? String,
            let viewIndex = viewConfig["index"] as? Int,
            let view = self.createUIViewObject(viewConfig: viewConfig) {
            superview.insertSubview(view, at: viewIndex)
            self.changeExecutor.execute(viewConfig, view: view)
            view.constraintsState = view.constraints.map { (constraint) -> NSLayoutConstraint in
                constraint
            }
            self.context.viewIndex[viewId] = view
        }
    }

    private func handleUIViewModify(_ viewConfig: [String: Any]) {
        if let id = viewConfig["id"] as? String,
            let view = self.context.viewIndex[id] {
            self.changeExecutor.execute(viewConfig, view: view)
        }
    }

    private func createUIViewObject(viewConfig: [String: Any]) -> UIView? {
        if let viewId = viewConfig["id"] as? String,
            let viewType = viewConfig["type"] as? String {
            let myclass = stringClassFromString(viewType) as! UIView.Type
            let view = myclass.init()
            if let uiButton = view as? UIButton {
                uiButton.titleLabel?.uid = UIViewIdentifier(value: String(format: "%@_label", viewId), kind: .custom)
            }
            view.uid = UIViewIdentifier(value: viewId, kind: .custom)
            return view
        }
        return nil
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
    // get namespace
    _ = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

    // get 'anyClass' with classname and namespace
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

func textStyle(from: String) -> UIFont.TextStyle? {
    switch from {
        case "Body":
            return UIFont.TextStyle.body
        case "Caption1":
            return UIFont.TextStyle.caption1
        case "Caption2":
            return UIFont.TextStyle.caption2
        case "Footnote":
            return UIFont.TextStyle.footnote
        case "Headline":
            return UIFont.TextStyle.headline
        case "Subheadline":
            return UIFont.TextStyle.subheadline
        case "Title1":
            if #available(iOS 9.0, *) {
                return UIFont.TextStyle.title1
            }
        case "Title2":
            if #available(iOS 9.0, *) {
                return UIFont.TextStyle.title2
            }
        case "Title3":
            if #available(iOS 9.0, *) {
                return UIFont.TextStyle.title3
            }
        case "Callout":
            if #available(iOS 9.0, *) {
                return UIFont.TextStyle.callout
            }
        case "LargeTitle":
            if #available(iOS 11.0, *) {
                return UIFont.TextStyle.largeTitle
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
    Foundation.Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
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

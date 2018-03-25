//
//  UIConfigProtocol.swift
//  TweaksDemo
//
//  Created by Nikolay Ivanov on 3/13/18.
//  Copyright © 2018 Nikolay Ivanov. All rights reserved.
//

import Foundation

@objc protocol UIViewOperationConfig {
    static var operation: String {get}
    static var view: UIViewContainerConfig {get}
}

@objc protocol UIViewContainerConfig {
    static var id: String {get}
    @objc optional static var type: String {get}
    @objc optional static var parentId: String {get}
    @objc optional static var index: Int {get}
    @objc optional static var props: UIViewPropertiesConfig {get}
    @objc optional static var constraints: UIViewConstraintsConfig {get}
    @objc optional static var frame: UIViewFrameConfig {get}
}

@objc protocol UIViewPropertiesConfig {}

@objc protocol UILabelPropertiesConfig: UIViewPropertiesConfig {
    static var text: String {get}
    static var textColor: String {get}
    static var backgroundColor: String {get}
}

@objc protocol UIViewConstraintsConfig {
    @objc optional static var top: Int {get}
    @objc optional static var topExpr: String {get}
    @objc optional static var leading: Int {get}
    @objc optional static var leadingExpr: String {get}
    @objc optional static var trailing: Int {get}
    @objc optional static var trailingExpr: String {get}
    @objc optional static var bottom: Int {get}
    @objc optional static var bottomExpr: String {get}
    @objc optional static var height: Int {get}
    @objc optional static var heightExpr: String {get}
}

@objc protocol UIViewFrameConfig {
    @objc optional static var x: Int {get}
    @objc optional static var xExpr: String {get}
    @objc optional static var y: Int {get}
    @objc optional static var yExpr: String {get}
    @objc optional static var height: Int {get}
    @objc optional static var heightExpr: String {get}
    @objc optional static var width: Int {get}
    @objc optional static var widthtExpr: String {get}
}


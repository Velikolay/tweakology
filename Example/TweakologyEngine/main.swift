//
//  main.swift
//  TweakologyEngine_Example
//
//  Created by Nikolay Ivanov on 6.07.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import TweakologyEngine

if #available(iOS 10.0, *) {
    UIApplicationMain(
        CommandLine.argc,
        CommandLine.unsafeArgv,
        NSStringFromClass(UIApplicationWithTweakology.self),
        NSStringFromClass(AppDelegate.self)
    )
} else {
    // Fallback on earlier versions
}

//
//  UIApplicationWithTweakology.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 6.07.19.
//

import UIKit
import Foundation

public class UIApplicationWithTweakology: UIApplication {
    override public func sendAction(_ action: Selector,
                                    to target: Any?,
                                    from sender: Any?,
                                    for event: UIEvent?) -> Bool {
        print("Received action: \(action), \(String(describing: target)), \(String(describing: sender)), \(String(describing: event))")
        return super.sendAction(action, to: target, from: sender, for: event);
    }
}

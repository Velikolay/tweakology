//
//  UIViewController+Tweakology.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/14/18.
//

import Foundation

extension UIViewController {

    private static var swizzleViewDidLoadImplementation: Void {
        let originalSelector = #selector(self.viewDidLoad)
        let swizzledSelector = #selector(self.proj_viewDidLoadSwizzled)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    @objc func proj_viewDidLoadSwizzled() {
        self.proj_viewDidLoadSwizzled()
        let viewControllerName = NSStringFromClass(type(of: self))
        print("viewDidLoad: \(viewControllerName)")
        if #available(iOS 10.0, *) {
            let viewIndex = self.inspectLayout()
            let tweaksStorage = TweakologyStorage.sharedInstance
            let engine = TweakologyLayoutEngine.sharedInstance
            engine.update(viewIndex: viewIndex)
            for (_, tweakSeq) in tweaksStorage.getAllTweaks() {
                engine.tweak(changeSeq: tweakSeq)
            }
        } else {
            // Fallback on earlier versions
        }
    }

    public static func swizzleViewDidLoad() {
        _ = self.swizzleViewDidLoadImplementation
    }
}

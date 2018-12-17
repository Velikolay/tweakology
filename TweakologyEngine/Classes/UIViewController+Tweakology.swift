//
//  UIViewController+Tweakology.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/14/18.
//

import Foundation

private var viewDidLoadKey: UInt8 = 0

extension UIViewController {
    
    private static var originalViewDidLoadImpl: [String: IMP] {
        get {
            return objc_getAssociatedObject(self, &viewDidLoadKey) as? [String: IMP] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &viewDidLoadKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func proj_viewDidLoadSwizzled() {
        let className = String(describing: type(of: self))
        print("viewDidLoad: \(className)")
        typealias MyCFunction = @convention(c) (AnyObject, Selector) -> Void
        var curriedImplementation: MyCFunction? = unsafeBitCast(UIViewController.originalViewDidLoadImpl[className], to: MyCFunction.self)
        if curriedImplementation == nil, let superClass = self.superclass {
            let superClassName = String(describing: superClass)
            curriedImplementation = unsafeBitCast(UIViewController.originalViewDidLoadImpl[superClassName], to: MyCFunction.self)
        }

        if let curriedImplementation = curriedImplementation {
            let originalSelector = #selector(viewDidLoad)
            curriedImplementation(self, originalSelector)
        }

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
    
    private static var swizzleViewDidLoadImplementation: Void {
        let originalSelector = #selector(viewDidLoad)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledSelector = #selector(proj_viewDidLoadSwizzled)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            let className = String(describing: self)
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                if let superClass = class_getSuperclass(self) {
                    let superClassName = String(describing: superClass)
                    if UIViewController.originalViewDidLoadImpl[superClassName] == nil {
                        UIViewController.originalViewDidLoadImpl[className] = method_getImplementation(originalMethod)
                    }
                }
            } else {
                UIViewController.originalViewDidLoadImpl[className] = method_setImplementation(originalMethod, method_getImplementation(swizzledMethod))
            }
        }
    }
    
    public static func swizzleViewDidLoad() {
        _ = self.swizzleViewDidLoadImplementation
    }
}

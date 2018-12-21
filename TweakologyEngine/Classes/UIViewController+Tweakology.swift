//
//  UIViewController+Tweakology.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/14/18.
//

import Foundation

private var originalViewDidLoadGlobalTableKey: UInt8 = 0
private var swizzledSuperClassKey: UInt8 = 0

extension UIViewController {

    private static var originalViewDidLoadGlobalTable: [String: IMP] {
        get {
            return objc_getAssociatedObject(self, &originalViewDidLoadGlobalTableKey) as? [String: IMP] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &originalViewDidLoadGlobalTableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var swizzledSuperclass: UIViewController.Type? {
        get {
            return objc_getAssociatedObject(self, &swizzledSuperClassKey) as? UIViewController.Type ?? nil
        }
        set {
            objc_setAssociatedObject(self, &swizzledSuperClassKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func proj_viewDidLoadSwizzled() {
        typealias MyCFunction = @convention(c) (AnyObject, Selector) -> Void
        if let originalImp = self.selectOriginalImp() {
            let originalFunc: MyCFunction? = unsafeBitCast(originalImp, to: MyCFunction.self)
            if let originalFunc = originalFunc {
                let originalSelector = #selector(viewDidLoad)
                originalFunc(self, originalSelector)
            }
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
    
    func selectOriginalImp() -> IMP? {
        let selfClass = type(of: self)
        let currClass = self.swizzledSuperclass ?? selfClass
        let className = String(describing: currClass)
        if let superclass = UIViewController.findNextSuperclassWithOriginalImp(subclass: currClass) {
            self.swizzledSuperclass = superclass
        } else {
            self.swizzledSuperclass = nil
        }
        return UIViewController.originalViewDidLoadGlobalTable[className]
    }

    private static var swizzleViewDidLoadImp: Void {
        let originalSelector = #selector(viewDidLoad)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledSelector = #selector(proj_viewDidLoadSwizzled)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            let className = String(describing: self)
            let didAddOriginalMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddOriginalMethod {
                if UIViewController.findNextSuperclassWithOriginalImp(subclass: self) == nil {
                    UIViewController.originalViewDidLoadGlobalTable[className] = method_getImplementation(originalMethod)
                }
            } else {
                UIViewController.originalViewDidLoadGlobalTable[className] = method_setImplementation(originalMethod, method_getImplementation(swizzledMethod))
            }
        }
    }
    
    private static func findNextSuperclassWithOriginalImp(subclass: AnyClass) -> UIViewController.Type? {
        if let superclass = class_getSuperclass(subclass) as? UIViewController.Type {
            let superclassName = String(describing: superclass)
            let originalFunc = UIViewController.originalViewDidLoadGlobalTable[superclassName]
            return (originalFunc != nil) ? superclass: UIViewController.findNextSuperclassWithOriginalImp(subclass: superclass)
        }
        return nil
    }

    private static func findNextSuperclassOriginalImp(subclass: AnyClass) -> IMP? {
        if let superclass = findNextSuperclassWithOriginalImp(subclass: subclass) {
            let superclassName = String(describing: superclass)
            return UIViewController.originalViewDidLoadGlobalTable[superclassName]
        }
        return nil
    }

    public static func swizzleViewDidLoad() {
        _ = self.swizzleViewDidLoadImp
    }
}

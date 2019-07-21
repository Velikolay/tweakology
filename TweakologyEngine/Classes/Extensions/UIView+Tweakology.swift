//
//  UIView+Tweakology.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 1.01.19.
//

import Foundation

private var originalDidAddSubviewGlobalTableKey: UInt8 = 0
private var swizzledSuperClassKey: UInt8 = 0

extension UIView {
    
    private static var originalDidAddSubviewGlobalTable: [String: IMP] {
        get {
            return objc_getAssociatedObject(self, &originalDidAddSubviewGlobalTableKey) as? [String: IMP] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &originalDidAddSubviewGlobalTableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var swizzledSuperclass: UIView.Type? {
        get {
            return objc_getAssociatedObject(self, &swizzledSuperClassKey) as? UIView.Type
        }
        set {
            objc_setAssociatedObject(self, &swizzledSuperClassKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func proj_didAddSubviewSwizzled(_ view: UIView) {
        typealias MyCFunction = @convention(c) (AnyObject, Selector, AnyObject) -> Void
        
        if let originalImp = self.selectOriginalImp() {
            let originalFunc: MyCFunction? = unsafeBitCast(originalImp, to: MyCFunction.self)
            if let originalFunc = originalFunc {
                let originalSelector = #selector(didAddSubview)
                originalFunc(self, originalSelector, view)
            }
        }
        if view != nil {
            assignUid(view)
        }
    }
    
    private func assignUid(_ view: UIView) {
        if view.uid == nil, let generatedUid = view.generateUID() {
            view.uid = UIViewIdentifier(value: generatedUid, kind: .generated)
            if #available(iOS 10.0, *) {
                TweakologyLayoutEngine.sharedInstance.viewIndex[view.uid!.value] = view
            }
        }
        //        view.constraintsState = view.constraints.map { (constraint) -> NSLayoutConstraint in
        //            constraint
        //        }
    }
    
    func selectOriginalImp() -> IMP? {
        let selfClass = type(of: self)
        let currClass = self.swizzledSuperclass ?? selfClass
        let className = String(describing: currClass)
        if let superclass = UIView.findNextSuperclassWithOriginalImp(subclass: currClass) {
            self.swizzledSuperclass = superclass
        } else {
            self.swizzledSuperclass = nil
        }
        return UIView.originalDidAddSubviewGlobalTable[className]
    }
    
    private static var swizzleDidAddSubviewImp: Void {
        let originalSelector = #selector(didAddSubview)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledSelector = #selector(proj_didAddSubviewSwizzled)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            let className = String(describing: self)
            let didAddOriginalMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddOriginalMethod {
                if UIView.findNextSuperclassWithOriginalImp(subclass: self) == nil {
                    UIView.originalDidAddSubviewGlobalTable[className] = method_getImplementation(originalMethod)
                }
            } else {
                UIView.originalDidAddSubviewGlobalTable[className] = method_setImplementation(originalMethod, method_getImplementation(swizzledMethod))
            }
        }
    }
    
    private static func findNextSuperclassWithOriginalImp(subclass: AnyClass) -> UIView.Type? {
        if let superclass = class_getSuperclass(subclass) as? UIView.Type {
            let superclassName = String(describing: superclass)
            let originalFunc = UIView.originalDidAddSubviewGlobalTable[superclassName]
            return (originalFunc != nil) ? superclass: UIView.findNextSuperclassWithOriginalImp(subclass: superclass)
        }
        return nil
    }
    
    private static func findNextSuperclassOriginalImp(subclass: AnyClass) -> IMP? {
        if let superclass = findNextSuperclassWithOriginalImp(subclass: subclass) {
            let superclassName = String(describing: superclass)
            return UIView.originalDidAddSubviewGlobalTable[superclassName]
        }
        return nil
    }
    
    public static func swizzleDidAddSubview() {
        _ = self.swizzleDidAddSubviewImp
    }
}

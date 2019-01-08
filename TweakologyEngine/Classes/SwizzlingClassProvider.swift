//
//  SwizzlingClassProvider.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 10/16/18.
//

import Foundation

public class SwizzlingClassProvider {
    public static let sharedInstance = SwizzlingClassProvider()
    
    public var uiViewControllerClasses: [UIViewController.Type]
    public var uiViewClasses: [UIView.Type]
    
    private init() {
        self.uiViewControllerClasses = getClasses(mainBundleOnly: true)
        self.uiViewClasses = getClasses(mainBundleOnly: false)
    }
}

func getClasses<T>(mainBundleOnly: Bool) -> [T.Type] {
    var classesToSwizzle: [T.Type] = []
    let classCount = Int(objc_getClassList(nil, 0))
    if classCount > 0 {
        let classes = UnsafeMutablePointer<AnyClass>.allocate(capacity: classCount)
        let safeTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        objc_getClassList(safeTypes, Int32(classCount))
        classesToSwizzle = getClassesOfType(classes: classes, classCount: classCount, parentClass: T.self)
        if mainBundleOnly {
            classesToSwizzle = getMainBundleClasses(classes: classesToSwizzle)
        }
        classes.deallocate()
    }
    return classesToSwizzle
}

func getClassesOfType<T>(classes: UnsafeMutablePointer<AnyClass>, classCount: Int, parentClass: T.Type) -> [T.Type] {
    var results: [T.Type] = [T.self]
    for index in 0 ..< classCount {
        var superclass: AnyClass? = class_getSuperclass(classes[index])
        while((superclass != nil) && superclass != parentClass)
        {
            superclass = class_getSuperclass(superclass);
        }
        
        if (superclass as? T.Type) != nil {
            if let nonNullClass = classes[index] as? T.Type {
                results.append(nonNullClass)
            }
        }
    }
    return results
}

func getMainBundleClasses<T>(classes: [T.Type]) -> [T.Type]
{
    var results: [T.Type] = []
    for index in 0 ..< classes.count {
        let bundle = Bundle(for: classes[index] as! AnyClass)
        if bundle == Bundle.main {
            results.append(classes[index])
        }
    }
    return results;
}

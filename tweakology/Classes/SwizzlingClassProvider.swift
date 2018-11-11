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

    private init() {
        self.uiViewControllerClasses = getUIViewControllerClasses()
    }
}

func getUIViewControllerClasses() -> [UIViewController.Type] {
    var classesToSwizzle: [UIViewController.Type] = []
    let classCount = Int(objc_getClassList(nil, 0))
    if classCount > 0 {
        let classes = UnsafeMutablePointer<AnyClass>.allocate(capacity: classCount)
        let safeTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        objc_getClassList(safeTypes, Int32(classCount))
        let subclasses = getSubclasses(classes: classes, classCount: classCount, parentClass: UIViewController.self)
        classesToSwizzle = getMainBundleClasses(classes: subclasses)
        classes.deallocate()
    }
    return classesToSwizzle
}

func getSubclasses<T>(classes: UnsafeMutablePointer<AnyClass>, classCount: Int, parentClass: T.Type) -> [T.Type] {
    var results: [T.Type] = []
    for index in 0 ..< classCount {
        var superClass: AnyClass? = class_getSuperclass(classes[index])
        while((superClass != nil) && superClass != parentClass)
        {
            superClass = class_getSuperclass(superClass);
        }

        if (superClass as? T.Type) != nil {
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

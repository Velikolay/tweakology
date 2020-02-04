//
//  UIControl+Mappable.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 18.08.19.
//

import Foundation
import ObjectMapper

extension UIControl.Event: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    public func mapping(map: Map) {
        String(describing: self) >>> map["name"]
        self.rawValue >>> map["value"]
    }
}

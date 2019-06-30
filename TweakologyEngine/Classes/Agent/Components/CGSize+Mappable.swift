//
//  CGSize+Mappable
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.19.
//

import Foundation
import ObjectMapper

extension CGSize: StaticMappable {
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }

    public func mapping(map: Map) {
        width >>> map["width"]
        height >>> map["height"]
    }
}

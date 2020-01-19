//
//  ActionProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 26.07.19.
//

import Foundation

@available(iOS 10.0, *)
protocol Action {
    func getId() -> String
    func execute()
    func toDTO() -> ActionDTO
}

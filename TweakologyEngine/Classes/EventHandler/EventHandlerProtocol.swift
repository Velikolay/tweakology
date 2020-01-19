//
//  EventHandlerProtocol.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 14.01.20.
//

import Foundation

@available(iOS 10.0, *)
protocol EventHandlerProtocol {
    func getId() -> String
    func handle(event: String)
    func toDTO() -> EventHandlerDTO
}

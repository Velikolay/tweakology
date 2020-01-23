//
//  ChangeExecutorFactory.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 23.01.20.
//

import Foundation

@available(iOS 10.0, *)
class ChangeExecutor {
    private let executors: [ChangeExecutorProtocol]

    init(_ context: ChangeExecutorContext) {
        self.executors = [
            UIImageViewExecutor(context),
            UIButtonExecutor(context),
            UILabelExecutor(context),
            UIControlExecutor(context),
            UIViewExecutor(context)
        ]
    }

    func execute(_ config: [String : Any], view: UIView) {
        var idx = 0
        var executed = false
        repeat {
            executed = self.executors[idx].execute(config, view: view)
            idx += 1
        } while idx < self.executors.count && !executed
    }
}

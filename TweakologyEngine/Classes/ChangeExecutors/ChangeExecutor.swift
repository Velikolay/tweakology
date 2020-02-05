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

    init(_ context: EngineContext) {
        self.executors = [
            UIImageViewExecutor(context),
            UIButtonExecutor(context),
            UILabelExecutor(context),
            UIControlExecutor(context),
            UIViewExecutor(context)
        ]
    }

    func execute(_ config: [String : Any], view: UIView) {
        let config = preprocessConfig(config)

        var idx = 0
        var executed = false
        repeat {
            executed = self.executors[idx].execute(config, view: view)
            idx += 1
        } while idx < self.executors.count && !executed
    }

    private func preprocessConfig(_ config: [String : Any]) -> [String: Any] {
        return config.mapValues { (value) -> Any in
            if let str = value as? String {
                return self.stringToAttributeValue(str: str)
            }
            if let obj = value as? [String: Any] {
                return preprocessConfig(obj)
            }
            return value
        }
    }

    private func stringToAttributeValue(str: String) -> Any {
        let pattern = "^\\s*\\{\\{\\s*([a-zA-Z0-9._-]+)\\s*\\}\\}\\s*$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return str }
        guard let match = regex.firstMatch(in: str, options: [], range: NSRange(str.startIndex..., in: str)) else { return str }
        let attributeName = String(str[Range(match.range(at: 1), in: str)!])
        return InMemoryAttributeStore.sharedInstance.get(key: attributeName) ?? str
    }
}

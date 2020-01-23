//
//  UIImageExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 22.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UIImageViewExecutor: UIViewExecutor {
    override func execute(_ config: [String : Any], view: UIView) -> Bool {
        if let uiimageview = view as? UIImageView {
            super.execute(config, view: view)
 
            if let properties = config["properties"] as? [String: Any] {
                if let image = properties["image"] as? [String: Any], let src = image["src"] as? String, !src.isEmpty {
                    if let url = URL(string: src), UIApplication.shared.canOpenURL(url) {
                        if (self.context.mode == EngineMode.production) {
                            uiimageview.sd_setImage(with: url)
                        } else {
                            let data = try? Data(contentsOf: url)
                            uiimageview.image = UIImage(data: data!)
                            uiimageview.image?.src = src
                        }
                    } else {
                        uiimageview.image = self.findImage(named: src)
                        uiimageview.image?.src = src
                    }
                }

                if let image = properties["highlightedImage"] as? [String: Any], let src = image["src"] as? String, !src.isEmpty {
                    if let url = URL(string: src), UIApplication.shared.canOpenURL(url) {
                        if (self.context.mode == EngineMode.production) {
                            uiimageview.sd_setHighlightedImage(with: url)
                        } else {
                            let data = try? Data(contentsOf: url)
                            uiimageview.highlightedImage = UIImage(data: data!)
                            uiimageview.highlightedImage?.src = src
                        }
                    } else {
                        uiimageview.highlightedImage = self.findImage(named: src)
                        uiimageview.highlightedImage?.src = src
                    }
                }
            }
            return true
        }
        return false
    }

    private func findImage(named: String) -> UIImage? {
        var image = UIImage(named: named)
        if image == nil {
            let bundle = Bundle(for: type(of: self))
            image = UIImage(named: named, in: bundle, compatibleWith: nil)
        }
        return image
    }
}

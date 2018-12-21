//
//  TweakologyAgent.swift
//  GCDWebServer
//
//  Created by Nikolay Ivanov on 4/13/18.
//

import Foundation
import GCDWebServer


@available(iOS 10.0, *)
@objc public class TweakologyAgent: NSObject {

    private let name: String
    private let storage: TweakologyStorage
    private let engine: TweakologyLayoutEngine

    @objc public init(name: String) {
        self.name = name
        self.engine = TweakologyLayoutEngine.sharedInstance
        self.storage = TweakologyStorage.sharedInstance
    }

    @objc public init(name: String, engine: TweakologyLayoutEngine) {
        self.name = name
        self.engine = engine
        self.storage = TweakologyStorage.sharedInstance
    }

    @objc public init(name: String, engine: TweakologyLayoutEngine, storage: TweakologyStorage) {
        self.name = name
        self.engine = engine
        self.storage = storage
    }

    @objc public func start() {

        let webServer = GCDWebServer()

        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow {
                    let recursiveDescriptionJson = window.toJSON()
                    let response = GCDWebServerDataResponse(jsonObject: recursiveDescriptionJson)
                    response?.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                    completionBlock(response)
                }
            }
        }
        
        webServer.addHandler(forMethod: "GET", path: "/fonts", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                let sysTextFontName = ".SFUIText"
                let sysDisplayFontName = ".SFUIDisplay"

                let systemFonts = [
                    "System": ["\(sysTextFontName)-UltraLight", "\(sysTextFontName)-Thin", "\(sysTextFontName)-Light", "\(sysTextFontName)", "\(sysTextFontName)-Medium", "\(sysTextFontName)-Semibold", "\(sysTextFontName)-Bold", "\(sysTextFontName)-Heavy", "\(sysTextFontName)-Black"],
                    "System Italic": ["\(sysTextFontName)-Italic"],
                ]

                var customFonts: [String: [String]] = [:]
                for familyName in UIFont.familyNames {
                    customFonts[familyName] = UIFont.fontNames(forFamilyName: familyName)
                }

                let fontsJson = [
                    "custom": customFonts,
                    "system": systemFonts,
                    "preffered": [
                        "Text Style": [
                            "TextStyle-Body": [ "fontName": sysTextFontName, "pointSize": 17 ],
                            "TextStyle-Callout": [ "fontName": sysTextFontName, "pointSize": 16 ],
                            "TextStyle-Caption1": [ "fontName": sysTextFontName, "pointSize": 12 ],
                            "TextStyle-Caption2": [ "fontName": sysTextFontName, "pointSize": 11 ],
                            "TextStyle-Footnote": [ "fontName": sysTextFontName, "pointSize": 13 ],
                            "TextStyle-Headline": [ "fontName": "\(sysTextFontName)-Semibold", "pointSize": 17],
                            "TextStyle-Subheadline": [ "fontName": sysTextFontName, "pointSize": 15 ],
                            "TextStyle-LargeTitle": [ "fontName": sysTextFontName, "pointSize": 28 ],
                            "TextStyle-Title1": [ "fontName": sysDisplayFontName, "pointSize": 28 ],
                            "TextStyle-Title2": [ "fontName": sysDisplayFontName, "pointSize": 22 ],
                            "TextStyle-Title3": [ "fontName": sysDisplayFontName, "pointSize": 20 ],
                        ]
                    ]
                ] as [String : Any]
                let response = GCDWebServerDataResponse(jsonObject: fontsJson)
                response?.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                completionBlock(response)
            }
        }

        webServer.addHandler(forMethod: "GET", pathRegex: "/images/[A-Za-z0-9_-]+", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow {
                    let params = request.path.split(separator: "/")
                    let viewId = String(params.last!)
                    var imageData: Data?
                    if let view = self.engine.viewIndex[viewId] {
                        let start = DispatchTime.now() // <<<<<<<<<< Start time
                        view.nonRecursiveRender()
                        imageData = UIImagePNGRepresentation(view.renderedImage)

                        let end = DispatchTime.now()   // <<<<<<<<<<   end time
                        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

                        print("Time to evaluate problem: \(timeInterval) seconds")
                    } else {
                        let image = window.renderImage()
                        imageData = UIImagePNGRepresentation(image!)
                    }

                    if imageData == nil {
                        imageData = Data()
                    }
                    let response = GCDWebServerDataResponse(data: imageData!, contentType: "image/png")
                    response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                    response.setValue("no-cache, no-store, must-revalidate", forAdditionalHeader: "Cache-Control")
                    completionBlock(response)
                }
            }
        }

        webServer.addHandler(forMethod: "PUT", pathRegex: "/tweaks/[A-Za-z0-9_-]+", request: GCDWebServerDataRequest.self) {
            (request: GCDWebServerRequest!, completionBlock: GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                if UIApplication.shared.keyWindow != nil {
                    let params = request.path.split(separator: "/")
                    let tweakName = String(params.last!)
                    if let tweakSeq = (request as? GCDWebServerDataRequest)?.jsonObject as? [[String:Any]] {
                        self.storage.addTweak(name: tweakName, changeSet: tweakSeq)
                        print(self.storage.getAllTweaks())
                        self.engine.tweak(changeSeq: tweakSeq)
                        let response = GCDWebServerResponse(statusCode: 204)
                        response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                        completionBlock(response)
                    } else {
                        let response = GCDWebServerResponse(statusCode: 400)
                        response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                        completionBlock(response)
                    }
                } else {
                    let response = GCDWebServerResponse(statusCode: 500)
                    response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                    completionBlock(response)
                }
            }
        }

        webServer.addHandler(forMethod: "OPTIONS", pathRegex: "/tweaks/[A-Za-z0-9_]+", request: GCDWebServerRequest.self) {
            (request: GCDWebServerRequest!, completionBlock: GCDWebServerCompletionBlock!) -> Void in
                let response = GCDWebServerResponse(statusCode: 200)
                response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                response.setValue("PUT", forAdditionalHeader: "Access-Control-Allow-Methods")
                response.setValue("Content-Type", forAdditionalHeader: "Access-Control-Allow-Headers")
                completionBlock(response)
        }

        webServer.start(withPort: 8080, bonjourName: "TweakologyAgent_\(self.name)")
        print("Visit \(String(describing: webServer.serverURL)) in your web browser")
    }
}

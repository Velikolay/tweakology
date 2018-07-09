//
//  TweakologyAgent.swift
//  GCDWebServer
//
//  Created by Nikolay Ivanov on 4/13/18.
//

import Foundation
import GCDWebServer


@available(iOS 10.0, *)
public class TweakologyAgent {

    private var tweaksStorage: TweaksStorage
    private var tweakologyEngine: TweakologyLayoutEngine

    public init(tweaksStorage: TweaksStorage, tweakologyEngine: TweakologyLayoutEngine) {
        self.tweaksStorage = tweaksStorage
        self.tweakologyEngine = tweakologyEngine
    }

    public func start() {
        
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
//                UIFontDescriptorTraitBold

                var fontNames = [
                    "System": ["System-UltraLight", "System-Thin", "System-Light", "System-Regular", "System-Medium", "System-Semibold", "System-Bold", "System-Heavy", "System-Black"],
                    "System Italic": ["SystemItalic-Regular"],
                    "Text Style": ["TextStyle-Body", "TextStyle-Callout", "TextStyle-Caption1", "TextStyle-Caption2", "TextStyle-Footnote", "TextStyle-Headline", "TextStyle-Subheadline", "TextStyle-Title1", "TextStyle-Title2", "TextStyle-Title3"]
                ]
                for familyName in UIFont.familyNames {
                    fontNames[familyName] = UIFont.fontNames(forFamilyName: familyName)
                }

                let fontsJson = [
                    "names": fontNames,
                    "families": ["System", "System Italic", "Text Style"] + UIFont.familyNames.sorted(by: { $0 < $1 }),
                    "systemFont": UIFont.systemFont(ofSize: 17).familyName
                ] as [String : Any]
                let response = GCDWebServerDataResponse(jsonObject: fontsJson)
                response?.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                completionBlock(response)
            }
        }

        webServer.addHandler(forMethod: "GET", path: "/images", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow {
                    var imageData: Data?
                    if let query = request.query,
                        let path = query["path"],
                        let pathString = path as? String,
                        let view = self.viewByPath(path: pathString, root: window) {
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

                    let response = GCDWebServerDataResponse(data: imageData!, contentType: "image/png")
                    response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
                    response.setValue("no-cache, no-store, must-revalidate", forAdditionalHeader: "Cache-Control")
                    completionBlock(response)
                }
            }
        }

        webServer.addHandler(forMethod: "PUT", pathRegex: "/tweaks/[A-Za-z0-9_]+", request: GCDWebServerDataRequest.self) {
            (request: GCDWebServerRequest!, completionBlock: GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow {
                    let params = request.path.split(separator: "/")
                    let tweakName = String(params.last!)
                    if let tweakSeq = (request as? GCDWebServerDataRequest)?.jsonObject as? [[String:Any]] {
                        self.tweaksStorage.addTweak(name: tweakName, changeSet: tweakSeq)
                        print(self.tweaksStorage.getAllTweaks())
                        self.tweakologyEngine.tweak(changeSeq: tweakSeq)
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

        webServer.start(withPort: 8080, bonjourName: "tweakology_agent")
        print("Visit \(String(describing: webServer.serverURL)) in your web browser")
    }

    func viewByPath(path: String, root: UIView) -> UIView? {
        var currNode = root
        for node in path.split(separator: "|") {
            let nodeParams = node.split(separator: ":")
            if !nodeParams[0].elementsEqual("UIWindow") {
                if let viewIdx = Int(nodeParams[1]),
                    currNode.subviews.count > viewIdx {
                    currNode = currNode.subviews[viewIdx]
                } else {
                    return nil
                }
            }
        }
        return currNode
    }
}

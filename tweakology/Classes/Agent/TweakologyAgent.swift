//
//  TweakologyAgent.swift
//  GCDWebServer
//
//  Created by Nikolay Ivanov on 4/13/18.
//

import Foundation
import GCDWebServer


public class TweakologyAgent {

    public init() {}
    
    public func start() {
        
        let webServer = GCDWebServer()
        
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async{
                if let window = UIApplication.shared.keyWindow {
                    let recursiveDescriptionJson = window.toJSON()
                    completionBlock(GCDWebServerDataResponse(jsonObject: recursiveDescriptionJson))
                }
            }
        }
        
        webServer.addHandler(forMethod: "GET", path: "/images", request: GCDWebServerRequest.self) {
            (request : GCDWebServerRequest!, completionBlock : GCDWebServerCompletionBlock!) -> Void in
            DispatchQueue.main.async{
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
                    completionBlock(GCDWebServerDataResponse(data: imageData!, contentType: "image/png"))
                }
            }
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

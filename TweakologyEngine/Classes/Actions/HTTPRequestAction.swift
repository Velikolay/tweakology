//
//  RESTRequestAction.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 7.08.19.
//

import Foundation

enum HTTPRequestMethod {
    case GET
    case POST
    case PUT
    case DELETE
}

enum HTTPRequestMedia {
    case JSON
}

protocol AsyncHTTPClient {
    func get(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class URLSessionAsyncHTTPClient: AsyncHTTPClient {
    func get(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                completionHandler(data, response, error)
            }
            task.resume()
        }
    }
}

@available(iOS 10.0, *)
class HTTPRequestAction: Action {
    private var id: String
    private var urlExpression: String
    private var attributeName: String?
    private var httpClient: AsyncHTTPClient
    private var attributeStore: AttributeStore
    private var expressionProcessor: ExpressionProcessor
    
    init(id: String, urlExpression: String, attributeName: String?, httpClient: AsyncHTTPClient, attributeStore: AttributeStore, expressionProcessor: ExpressionProcessor) {
        self.id = id
        self.urlExpression = urlExpression
        self.attributeName = attributeName
        self.httpClient = httpClient
        self.attributeStore = attributeStore
        self.expressionProcessor = expressionProcessor
    }
    
    func getId() -> String {
        return id
    }
    
    func execute() {
        if let urlStr = expressionProcessor.process(expression: self.urlExpression, context: self.attributeStore.getAll()) {
            self.httpClient.get(url: urlStr) {(data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    if let attributeName = self.attributeName {
                        self.attributeStore.set(key: attributeName, value: jsonResponse)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    func toDTO() -> ActionDTO {
        return ActionDTO(JSON: [
            "id": id,
            "type": "HTTPRequest",
            "args": [
                "attributeName": attributeName,
                "urlExpression": urlExpression
            ]
        ])!
    }
}

//
//  WebService.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public enum WebServiceError: ErrorProtocol {
    case invalidResponse
    case message(String)
    case data(Data?)
    case modelParsing
}

public struct WebService<Model>: Equatable {
    
    public typealias ErrorParser = (data: Data?, urlResponse: URLResponse?, error: NSError?) -> ErrorProtocol
    public typealias SuccessHandler = (model: Model) -> Void
    public typealias FailHandler = (statusCode: Int?, error: ErrorProtocol) -> Void
    
    
    // MARK: Property

    public let webResource: WebResource<Model>
    
    
    // MARK: Init
    
    public init(webResource: WebResource<Model>) { self.webResource = webResource }
    
    
    // MARK: Request
    
    // TODO:
    // 1. Option for go back to main queue automatically.
    // 2. Option for errorParser.
    
    public func request(with urlSession: URLSession, errorParser: ErrorParser? = nil, successHandler: SuccessHandler, failHandler: FailHandler? = nil) -> URLSessionTask {
        
        let sessionTask = urlSession.dataTask(with: webResource.urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                
                failHandler?(statusCode: nil, error: WebServiceError.invalidResponse)
                
                return
                
            }
            
            let statusCode = response.statusCode
            
            if let errorParsingError = errorParser?(data: data, urlResponse: response, error: error) {
                
                failHandler?(statusCode: statusCode, error: errorParsingError)
                
                return
                
            }
            
            if let error = error {
                
                let serverError: WebServiceError = .message(error.localizedDescription)
                
                failHandler?(statusCode: statusCode, error: serverError)
                
                return
            
            }
            
            if !self.validate(withStatusCode: statusCode) {
             
                let serverError: WebServiceError = .message(NSLocalizedString("Unaccepted status code.", comment: ""))
                
                failHandler?(statusCode: statusCode, error: serverError)
                
                return
                
            }
            
            do {
                
                let data = data ?? Data()
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let model = self.webResource.parse(json: jsonObject) else {
                    
                    let error: WebServiceError = .modelParsing
                    
                    failHandler?(statusCode: nil, error: error)
                    
                    return
                    
                }
                
                successHandler(model: model)
                
            }
            catch { failHandler?(statusCode: statusCode, error: error) }
        
        }
        
        sessionTask.resume()
        
        return sessionTask
        
    }
    
    
    // MARK: Validate
    
    private func validate(withStatusCode statusCode: Int) -> Bool {
        
        switch statusCode {
        case 200..<300: return true
        default: return false
        }
        
    }
    
}


// MARK: Equatable

public func ==<Model>(lhs: WebService<Model>, rhs: WebService<Model>) -> Bool {
    
    return lhs.webResource == rhs.webResource
    
}

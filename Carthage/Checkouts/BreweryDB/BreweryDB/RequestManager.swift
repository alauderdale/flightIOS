//
//  RequestManager.swift
//  BreweryDB
//
//  Created by Jake Welton on 2016-07-21.
//  Copyright © 2016 Jake Welton. All rights reserved.
//

import Foundation

public protocol BreweryDBRequest {
    var endpoint: RequestEndPoint { get }
    var rawParams: [String: String]? { get }
    var rawOrderBy: String? { get }
    var pageNumber: Int { get set }
}

open class RequestManager<Type: JSONParserEntity> {
    fileprivate let requestBuilder: RequestBuilder
    fileprivate var urlRequest: URLRequest
    open var request: BreweryDBRequest
    open var requestURL: URLRequest {
        return urlRequest
    }
    open var currentPageNumber: Int {
        return request.pageNumber
    }
    
    public init?(request: BreweryDBRequest) {
        requestBuilder = RequestBuilder(endPoint: request.endpoint)
        
        guard let url = requestBuilder.buildRequest(request) else {
            return nil
        }
        
        self.request = request
        urlRequest = url
    }
    
    open func fetch(using completionHandler: @escaping ([Type]?)->Void) {
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let returnedData = data,
                let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                    completionHandler(nil)
                    return
            }
            
            let jsonParser = JSONParser<Type>(rawData: returnedData)
            jsonParser?.extractObjects(using: completionHandler)
            
            }) .resume()
    }
    
    open func fetchNextPage(using completionHandler: @escaping ([Type]?)->Void) {
        request.pageNumber += 1
        
        guard let url = requestBuilder.buildRequest(request) else {
            completionHandler(nil)
            return
        }
        
        urlRequest = url
        
        fetch(using: completionHandler)
    }
    
    open func cancel() {
        URLSession.shared.invalidateAndCancel()
    }
}

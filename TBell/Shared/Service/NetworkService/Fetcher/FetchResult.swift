//
//  FetchResult.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Describes result of a fetch request sent to Fetcher.
struct FetchResult {
    
    let httpResponse : HTTPURLResponse
    let httpResponseBody : Data
}

extension FetchResult {
    
    /// Returns the response body and status as string. For debugging purposes only.
    var description : String {
        
        return  "Status Code : \(self.httpResponse.statusCode) " + ". Body : " + (String(data: self.httpResponseBody, encoding: .utf8) ?? "")
    }
    
    /// Confirm that the server's response is 200.
    /// If http status code is anything else it throws NetworkError with error type "nonSuccessHttpStatusCode".
    func isSuccessHttpResponse() throws {
        
        switch self.httpResponse.statusCode {
            
        case HTTPStatusCode.ok.rawValue:
            break
            
        default: // any other http status code
            
            throw NetworkError(errorType: .nonSuccessHttpStatusCode)
            
        } // end switch
    } // end func
    
    /// Extracts the json from http response and returns it if http status code is 200.
    /// If http response doesn't contain a valid json, it throws NetworkError with error type "invalidResponse".
    /// If http status code is anything else it throws NetworkErro with error type "nonSuccessHttpStatusCode".
    func extractJsonFromHttpResponse<R>() throws -> R {
        
        // make sure response is 200
        try self.isSuccessHttpResponse()
        
        // extract json from http response
        guard let json = JSONSerialization.dictionary(fromJson: self.httpResponseBody) as? R else {
            
            throw NetworkError(errorType: .invalidResponse)
        }
        
        return json
    } // end func
    
    /// Extracts a decoable object from http response and returns it if http status code is 200.
    /// If http response doesn't contain a valid decoable, it throws NetworkError with error type "invalidResponse".
    /// If http status code is anything else it throws NetworkErrorwith error type "nonSuccessHttpStatusCode".
    func extractDecoableObjectFromHttpResponse<D : Decodable>() throws -> D {
        
        // make sure response is 200
        try self.isSuccessHttpResponse()
        
        do {
            return try JSONDecoder().decode(D.self, from: self.httpResponseBody)
        } catch {
            
            throw NetworkError(errorType: .invalidResponse)
        }
    } // end func
}


//
//  URLRequest+HelperMethods.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Set of helper methods for network services.
extension URLRequest {
    
    //MARK: - Http Header
    
    /// Adds a value for header field for urlrequest.
    mutating func addHeader(value : String, forHeaderField headerField :String) {
        self.setValue(value, forHTTPHeaderField: headerField)
    }
    
    /// Adds access token to urlrequest header.
    mutating func addAuthorizationToHeader(accessToken : String) {
        
        self.setValue(authorizationBearer + accessToken, forHTTPHeaderField: authorizationKey)
    }
    
    /// Adds JSON content-type to urlrequest header.
    mutating func addJsonContentTypeToHeader() {
        self.setValue(jsonContentType, forHTTPHeaderField: contentTypeKey)
    }
    
    /// Adds x-www-form-urlencoded content-type to urlrequest header.
    mutating func addFormUrlEncodedContentTypeToHeader() {
        self.setValue(formURLEncodedContentType, forHTTPHeaderField: contentTypeKey)
    }
    
    //MARK: - Http Methods
    
    /// Adds HTTP method to url request.
    mutating func addHttpMethod(_ httpMethod : HTTPMethod) {
        
        self.httpMethod = httpMethod.rawValue
        
    } // end func
    
    //MARK: - Http Body
    
    /// Receives a dictionary, converts it to json and adds it to http body.
    mutating func addJsonToBody(_ jsonDic : [String:Any]) {
        self.httpBody = JSONSerialization.jsonFrom(dictionary: jsonDic)
    }
} // end extension

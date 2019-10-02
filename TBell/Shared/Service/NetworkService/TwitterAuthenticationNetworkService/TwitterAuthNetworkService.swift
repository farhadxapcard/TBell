//
//  TwitterAuthNetworkService.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation
import PromiseKit

fileprivate struct Constants {
    
    /// Url for Application only Authentication.
    static let oauth2TokenUrl = URL(string: "https://api.twitter.com/oauth2/token")!
    
    /// Bearer string to insert before accessToken for Authorization Header
    static let authorizationBearer = "Basic"
    
    /// Key and Value for http post body of oauth2Token request.
    static let grantTypeKey = "grant_type"
    static let grantTypeValue = "client_credentials"
    
    /// Key and Value for http post response of oauth2Token request.
    static let tokenTypeKey = "token_type"
    static let tokenTypeValue = "bearer"
    static let accessTokenKey = "access_token"
}

class TwitterAuthNetworkService {
    
    //MARK: - Private Properties
    private let fetcher : FetcherProtocol = Fetcher()
    
    /// If access token is fetched from twitter, it will not be nil.
    private var accessToken : String?
}

//MARK: - Public Methods
extension TwitterAuthNetworkService {
    
    /// Fetches the access token for App Only Authentication. If access token is already fetched, it returns it.
    /// In case of error, Error type would be NetworkError.
    func fetchAccessToken() -> Promise<String> {
        
        // if we already have access token, return it
        if let accessToken = self.accessToken {
            return Promise {$0.fulfill(accessToken)}
        }
        
        // create a post request
        return
            firstly { () -> Promise<URLRequest> in
                
                // url encode api and secret keys
                guard let urlEncodeApiKey = twitterApiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let urlEncodedSecretKey = twitterApiSecretKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                        
                        throw NetworkError(errorType: .invalidRequest)
                }
                
                // convert final key to data
                guard let data = (urlEncodeApiKey + ":" + urlEncodedSecretKey).data(using: .utf8) else {
                    
                    throw NetworkError(errorType: .invalidRequest)
                }
                // base64 encode it
                let base64Key = data.base64EncodedString()
                
                // create request
                var urlRequest = URLRequest(url: Constants.oauth2TokenUrl)
                
                // add http method
                urlRequest.addHttpMethod(.post)
                
                // add content type
                urlRequest.addFormUrlEncodedContentTypeToHeader()
                
                // add authorization header
                urlRequest.addValue(Constants.authorizationBearer + " " + base64Key, forHTTPHeaderField: authorizationKey)
                
                // add grant_type to body
                urlRequest.httpBody = (Constants.grantTypeKey + "=" + Constants.grantTypeValue).data(using: .utf8)
                
                return Promise {$0.fulfill(urlRequest)}
                
            }.then { request in
                
                // fetch the request
                self.fetcher.fetch(request: request)
                
            }.map { fetchResult in
                
                // convert response to dictionary
                let responseDic : [String:String] = try fetchResult.extractJsonFromHttpResponse()
                
                // validate response
                guard let tokenType = responseDic[Constants.tokenTypeKey],
                    let accessToken = responseDic[Constants.accessTokenKey],
                    tokenType == Constants.tokenTypeValue else {
                        
                        throw NetworkError(errorType: .invalidResponse)
                }
                
                return accessToken
                
            }.get(on: DispatchQueue.main) { accessToken in
                
                // retain the access token
                self.accessToken = accessToken
        }
    } // end func
}

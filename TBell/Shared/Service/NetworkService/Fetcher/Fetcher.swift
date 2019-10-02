//
//  Fetcher.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation
import PromiseKit

/// Fetches a urlRequest async and returns the result.
final class Fetcher : NSObject {
    
    //MARK: - Private Properties
    fileprivate lazy var serialQueue : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    fileprivate var _urlSession : URLSession!
    fileprivate var urlSession : URLSession {
        
        if _urlSession == nil {
            
            // create config
            let configuration = URLSessionConfiguration.default
            
            // disable cache
            configuration.urlCache = nil
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            
            _urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: self.serialQueue)
        } // end if
        
        return _urlSession
    } // end var
} // end class

//MARK: - FetcherProtocol
extension Fetcher : FetcherProtocol {
    
    func fetch(request : URLRequest) -> Promise<FetchResult> {
        
        return Promise() { seal in
            
            // create data task
            let dataTask = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                // error
                if let error = error as NSError? {
                    
                    switch (error.domain,error.code) {
                        
                    case (NSURLErrorDomain, NSURLErrorCancelled): // cancelled
                        seal.reject(NetworkError(errorType: .otherNetworkError))
                        
                    case (NSURLErrorDomain, NSURLErrorNotConnectedToInternet): // no internet
                        seal.reject(NetworkError(errorType: .noInternetConnection))
                        
                    case (NSURLErrorDomain, NSURLErrorNetworkConnectionLost): // network connection lost
                        seal.reject(NetworkError(errorType: .networkConnectionLost))
                        
                    default: // other network error
                        seal.reject(NetworkError(errorType: .otherNetworkError))
                    } // end switch
                    
                    return
                } // end if
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(NetworkError(errorType: .invalidResponse))
                    
                    // this should never happen
                    return
                }
                
                // success,
                // sometimes the response doesn't have any body so if data (http response body) is nil, pass an empty data to prevent caller to deal with optionals
                seal.fulfill(FetchResult(httpResponse: httpResponse, httpResponseBody: data ?? Data()))
                
            } // end dataTask
            
            // start the task
            dataTask.resume()
        } // end Promise
    } // end func
    
    func invalidateSession(cancelCurrentTasks: Bool) {
        
        if cancelCurrentTasks {
            self.urlSession.invalidateAndCancel()
        }
        else {
            self.urlSession.finishTasksAndInvalidate()
        }
    } // end func
} // end extension

//MARK: - URLSessionTaskDelegate
extension Fetcher : URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        /// prevent redirection
        completionHandler(nil)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        // nullify the session because it's not reusable
        _urlSession = nil
    }
    
} // end extension

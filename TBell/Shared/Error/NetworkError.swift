//
//  NetworkError.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Represents a network error.
class NetworkError : LocalizedError {
    
    /// Represents a network error type
    enum ErrorType {
        
        case noInternetConnection
        
        /// Network connection is temporary lost.
        case networkConnectionLost
        
        /// Indicates the app cannot create a valid url request based on passed parameters.
        case invalidRequest
        
        /// Indicates the response received from server is not a valid response.
        case invalidResponse
        
        /// Received http status code from server is not success (200).
        case nonSuccessHttpStatusCode
        
        /// Other network error.
        case otherNetworkError
    } // end enum
    
    //MARK: - Public Properties
    let errorType : ErrorType
    
    init(errorType : ErrorType) {
        self.errorType = errorType
    }
    
    var errorDescription: String? {
        return self.localizedDescription
    }
    
    var localizedDescription: String {
        
        switch self.errorType {
            
        case .noInternetConnection:
            return NSLocalizedString("You're offline", comment: "No Internet connection")
            
        default:
            return NSLocalizedString("Network error. Please try again", comment: "Network error. Please try again")
        } // end switch
    } // end var
}

//
//  HTTPStatusCode.swift
//  NetworkFramework
//
//  Created by Farhad on 2018-10-12.
//  Copyright © 2018 XapCard. All rights reserved.
//

import Foundation

/// Describes HTTP Status Codes.
enum HTTPStatusCode : Int {
    
    //MARK: 2XX
    case ok = 200
    case noContent = 204
    case partialContent = 206
    
    //MARK: 3XX
    case found = 302
    
    //MARK: 4XX
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case notAcceptable = 406
    case conflict = 409
    case gone = 410
    case preconditionFailed = 412
    case preconditionRequired = 428
    
} // end enum

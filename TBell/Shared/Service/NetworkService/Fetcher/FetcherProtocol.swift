//
//  FetcherProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation
import PromiseKit

/// Fetches a urlRequest async and returns the result.
protocol FetcherProtocol {
    
    /// Fetches a request async and returns the result.
    /// In case of other error, the error type is NetworkError.
    func fetch(request : URLRequest) -> Promise<FetchResult>
    
    /// Invalidates the session.
    /// Allows current tasks to finish unless cancelCurrentTasks flag is true.
    func invalidateSession(cancelCurrentTasks: Bool)
}


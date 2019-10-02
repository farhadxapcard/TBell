//
//  NetworkServiceProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import CoreLocation
import PromiseKit
import TwitterKit
import TwitterCore

protocol NetworkServiceProtocol {
    
    /// Twitter Api Client.
    var twitterApiClient : TWTRAPIClient { get }
    
    /// Allows user to login into Twitter. If user is previously logged in, the login flow is not shown again.
    func loginToTwitter() -> Promise<Void>
    
    /// Fetches tweets that have geo locations and return them.
    func fetchTweets(withSearchText searchText : String, aroundLocationWithCoordinates coordinates : CLLocationCoordinate2D, withRadius radius : Int) -> Promise<[GeoTweet]>
}

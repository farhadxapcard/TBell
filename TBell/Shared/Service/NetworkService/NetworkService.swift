//
//  NetworkService.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import CoreLocation
import PromiseKit
import TwitterKit
import TwitterCore

fileprivate struct Constants {
    
    static let statusesKey = "statuses"
    static let searchUrl = URL(string: "https://api.twitter.com/1.1/search/tweets.json")!
    static let queryKey = "q"
    static let geocodeKey = "geocode"
    static let resultTypeKey = "result_type"
    static let resultTypeValue = "recent"
    static let km = "km"
    static let coordinatesKey = "coordinates"
    static let geoKey = "geo"
}

class NetworkService {
    
    //MARK: - Public Properties
    let twitterApiClient = TWTRAPIClient()
    
    //MARK:- Private Properties
    
    /// Logged in user's session.
    private var twitterSession : TWTRSession?
    
    lazy private var twitterAuthNetworkService = TwitterAuthNetworkService()
}

//MARK: - NetworkServiceProtocol
extension NetworkService : NetworkServiceProtocol {
    
    func fetchTweets(withSearchText searchText : String, aroundLocationWithCoordinates coordinates : CLLocationCoordinate2D, withRadius radius : Int) -> Promise<[GeoTweet]> {
        
        return Promise { seal in
            
            // create url
            guard var urlComponents = URLComponents(url: Constants.searchUrl, resolvingAgainstBaseURL: false) else {
                
                seal.reject(NetworkError(errorType: .invalidRequest))
                return
            }
            
            var queryItems = [URLQueryItem]()
            
            // add search query
            queryItems.append(URLQueryItem(name: Constants.queryKey, value: searchText))
            
            // add geocode
            queryItems.append(URLQueryItem(name: Constants.geocodeKey, value: "\(coordinates.latitude)" + "," + "\(coordinates.longitude)" + "," + "\(radius)" + Constants.km))
            
            // add result type
            queryItems.append(URLQueryItem(name: Constants.resultTypeKey, value: Constants.resultTypeValue))
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                seal.reject(NetworkError(errorType: .invalidRequest))
                return
            }
            
            // create urlRequest
            let urlRequest = URLRequest(url: url)
            
            self.twitterApiClient.sendTwitterRequest(urlRequest) { (response, data, error) in
                
                // if error, reject
                if let error = error {
                    seal.reject(error)
                    return
                }
                
                guard let jsonData = data else {
                    seal.reject(NetworkError(errorType: .invalidResponse))
                    return
                }
                
                // holds an array of dictionary (each dictionary is a tweet)
                var tweetsJsonDictionary : [[AnyHashable : Any]] = []
                
                // if json data is a dictionary
                if let jsonDic = JSONSerialization.dictionary(fromJson: jsonData),
                    let tweetsDic = jsonDic[Constants.statusesKey] as? [[AnyHashable : Any]] {
                    
                    tweetsJsonDictionary = tweetsDic
                    
                    // if json data is an array
                } else if let jsonArray = JSONSerialization.array(fromJson: jsonData) as? [[AnyHashable : Any]] {
                    
                    tweetsJsonDictionary = jsonArray
                } // end if
                
                // convert tweets dictionary to geo tweets
                seal.fulfill( tweetsJsonDictionary.compactMap {self.p_createGeoTweet(withJsonDictionary: $0)})
            } // end completion handler
        } // end promise
    } // end func
    
    /// Creates a GeoTweet from a json dictionary that is obtained from Twitter API. If tweet doesn't have geo location or it's not a valid json dictionary, returns nil.
    func p_createGeoTweet(withJsonDictionary jsonDictionary : [AnyHashable : Any]) -> GeoTweet? {
        
        var coordinate : CLLocationCoordinate2D?
        
        // try to get coordinates from geo object
        if let geoObject = jsonDictionary[Constants.geocodeKey] as? [String:Any],
            let coordinatesArray = geoObject[Constants.coordinatesKey] as? [Double],
            coordinatesArray.count >= 2 {
            
            coordinate = CLLocationCoordinate2D(latitude: coordinatesArray[0], longitude: coordinatesArray[1])
        }
            // try to get coordinates from coordinate object
        else if let coordinatesObject = jsonDictionary[Constants.coordinatesKey] as? [String:Any],
            let coordinatesArray = coordinatesObject[Constants.coordinatesKey] as? [Double],
            coordinatesArray.count >= 2 {
            
            coordinate = CLLocationCoordinate2D(latitude: coordinatesArray[0], longitude: coordinatesArray[1])
        }
        
        // create tweet object
        guard let tweetCoordinate = coordinate,
            let tweetObject = TWTRTweet(jsonDictionary: jsonDictionary) else {
                
                return nil
        }
        
        return GeoTweet(tweetObject: tweetObject, coordinate: tweetCoordinate)
    } // end func
}

//MARK: - Twitter Login
extension NetworkService {
    
    func loginToTwitter() -> Promise<Void> {
        
        // if user is already logged in, don't show the login flow.
        guard self.twitterSession == nil else {
            
            return Promise()
        }
        
        return Promise { seal in
            
            TWTRTwitter.sharedInstance().logIn { session, error in
                
                DispatchQueue.main.async {
                    
                    self.twitterSession = session
                    
                    // success
                    if session != nil {
                        seal.fulfill(())
                    }
                        // login failed
                    else {
                        seal.reject(error ?? NetworkError(errorType: NetworkError.ErrorType.otherNetworkError))
                    }
                } // end async
            } // end completion handler
        } // end promise
    } // end func
}

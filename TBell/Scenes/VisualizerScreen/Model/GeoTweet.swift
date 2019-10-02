//
//  GeoTweet.swift
//  TBell
//
//  Created by Farhad on 2019-10-01.
//  Copyright © 2019 Farhad. All rights reserved.
//

import CoreLocation
import TwitterKit
import TwitterCore

/// Represents a tweet object with geo coordinates that is fetched from Twitter API.
class GeoTweet : NSObject {
    
    //MARK: - Properties
    let tweetObject : TWTRTweet
    let coordinate : CLLocationCoordinate2D
    lazy private(set) var authorImage : UIImage? = {
        
        guard let url = URL(string: self.tweetObject.author.profileImageMiniURL),
            let data = try? Data(contentsOf: url) else {
                
                return nil
        }
        return UIImage(data: data)
    }()
    
    //MARK: - Init
    init(tweetObject : TWTRTweet, coordinate : CLLocationCoordinate2D) {
        
        self.tweetObject = tweetObject
        self.coordinate = coordinate
        super.init()
    }
}

//MARK: - TweetPinAnnotationViewDataProtocol
extension GeoTweet : TweetPinAnnotationViewDataProtocol {
    
    var title: String? {
        return self.tweetObject.author.formattedScreenName
    }
    
    var subtitle: String? {
        return self.tweetObject.text
    }
    
}

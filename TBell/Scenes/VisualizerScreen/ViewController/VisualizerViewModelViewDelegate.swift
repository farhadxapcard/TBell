//
//  VisualizerViewModelViewDelegate.swift
//  TBell
//
//  Created by Farhad on 2019-10-01.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit
import TwitterCore

/// Allows VisualizerViewModel to send messages to VisualizerViewController.
protocol VisualizerViewModelViewDelegate : class {
    
    /// Informs viewcontroller to show an alert that no tweets are found
    func showAlertNoTweetsFound()
    
    //MARK: - Error
    
    /// Asks viewcontroller to show the error
    func displayError(_ error : Error)
    
    /// Asks viewcontroller to display the error that location authorization is denied.
    func displayNotAuthorizedLocationError()
    
    //MARK: - Radius
    
    /// Informs viewcontroller to set the radius segment titles.
    func setRadiusSegmentTitles(to segmentTitles : [String])
    
    /// Asks viewcontroller to update the selected radius segment index.
    func setSelectedRadiusSegmentIndex(to selectedIndex : Int)
    
    /// Informs viewcontroller to update radius label.
    func updateRadiusLabel(to newText : String)
    
     //MARK: - Map
    
    /// Asks viewcontroller to show geo tweets on the map.
    func showGeoTweetsOnMap(_ tweets : [TweetPinAnnotationViewDataProtocol])
    
    /// Informs viewcontroller to set the map region.
    func setMapRegion(to newRegion : MKCoordinateRegion)
    
    //MARK: - Tweet
    
    /// Asks viewcontroller to show a tweet view.
    func showTweetView(withTweetObject tweetObject : TWTRTweet)
}

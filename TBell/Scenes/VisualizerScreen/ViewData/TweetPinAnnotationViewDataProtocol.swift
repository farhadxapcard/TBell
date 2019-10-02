//
//  TweetPinAnnotationViewDataProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-10-02.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit
import TwitterCore

/// Allows VisualizerViewModel to send model (geo tweets) to VisualizerViewController to show as pins on the map.
protocol TweetPinAnnotationViewDataProtocol : MKAnnotation {
    
    /// Author image.
    var authorImage : UIImage? { get }
}

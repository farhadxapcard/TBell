//
//  TweetPinAnnoationView.swift
//  TBell
//
//  Created by Farhad on 2019-10-01.
//  Copyright © 2019 Farhad. All rights reserved.
//

import MapKit

/// Represents a tweet on the map.
class TweetPinAnnoationView : MKPinAnnotationView {
    
    //MARK: - Constants
    static let reusableIdentifier = "TweetPinAnnoationView"
    
    //MARK: - Init
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.p_commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.p_commonInit()
    }
    
    private func p_commonInit() {
        
        // set right callout as a button
        self.canShowCallout = true
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
    } // end func
}

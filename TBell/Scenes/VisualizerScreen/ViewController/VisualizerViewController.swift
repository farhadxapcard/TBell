//
//  VisualizerViewController.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit
import TwitterCore

class VisualizerViewController: UIViewController {
    
    //MARK: - Public Properties
    var viewModel : VisualizerViewModelProtocol! {
        didSet {
            self.viewModel.viewDelegate = self
        }
    }
    
    //MARK: - Properties Radius
    @IBOutlet weak var segmentRadius: UISegmentedControl!
    @IBOutlet weak var lblRadius: UILabel!
    
    //MARK: - Properties MapView
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            
            mapView.delegate = self
            mapView.register(TweetPinAnnoationView.self, forAnnotationViewWithReuseIdentifier: TweetPinAnnoationView.reusableIdentifier)
        }
    } // end var
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        
        // start viewmodel
        self.viewModel.start()
    } // end func
    
}

//MARK: - Button Actions
extension VisualizerViewController {
    
    /// Gets called when user taps on Back Button.
    @IBAction func btnBackTapped(_ sender : UIBarButtonItem) {
        self.viewModel.didTapBackButton()
    }
}

//MARK: - VisualizerViewModelViewDelegate
extension VisualizerViewController : VisualizerViewModelViewDelegate {
    
    func showAlertNoTweetsFound() {
        
        // display an alert
        self.showAlert(title: NSLocalizedString("No Tweets Found", comment: "No Tweets Found"), message: NSLocalizedString("No tweets found around your current location. Try to widen your radius please", comment: "No tweets found around your current location. Try to widen your radius please"), buttonTitle: NSLocalizedString("OK", comment: "OK"), buttonHandler: nil)
    } // end func
}

//MARK: - Radius
extension VisualizerViewController {
    
    @IBAction func segmentRadiusValueChanged(_ sender: UISegmentedControl) {
        
        self.viewModel.didSelectRadiusSegment(atIndex: sender.selectedSegmentIndex)
    }
    
    func setRadiusSegmentTitles(to segmentTitles: [String]) {
        
        // remove all segments
        self.segmentRadius.removeAllSegments()
        
        // add new segments with title
        for (index,segmentTitle) in segmentTitles.enumerated() { self.segmentRadius.insertSegment(withTitle: segmentTitle, at: index, animated: false)
        } // end for
    } // end func
    
    func setSelectedRadiusSegmentIndex(to selectedIndex: Int) {
        self.segmentRadius.selectedSegmentIndex = selectedIndex
    }
    
    func updateRadiusLabel(to newText: String) {
        self.lblRadius.text = newText
    }
}

//MARK: - Map
extension VisualizerViewController : MKMapViewDelegate {
    
    func showGeoTweetsOnMap(_ tweets : [TweetPinAnnotationViewDataProtocol]) {
        
        // remove current annotations except current user's annotation
        self.mapView.removeAnnotations(self.mapView.annotations.filter {!$0.isKind(of: MKUserLocation.self)})
        
        // add them to the map
        self.mapView.addAnnotations(tweets)
    } // end func
    
    func setMapRegion(to newRegion: MKCoordinateRegion) {
        self.mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // if it's user location, return nil
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var tweetPinAnnoationView = mapView.dequeueReusableAnnotationView(withIdentifier: TweetPinAnnoationView.reusableIdentifier, for: annotation) as? TweetPinAnnoationView
        
        if tweetPinAnnoationView == nil {
            tweetPinAnnoationView = TweetPinAnnoationView(annotation: annotation, reuseIdentifier: TweetPinAnnoationView.reusableIdentifier)
        }
        else {
            tweetPinAnnoationView?.annotation = annotation
        }
        
        return tweetPinAnnoationView
    } // end func
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // get tweet annotation view data
        guard let tweetPinAnnotationView = view as? TweetPinAnnoationView,
            let tweetPinAnnotationViewData = tweetPinAnnotationView.annotation as? TweetPinAnnotationViewDataProtocol else {
                return
        }
        
        self.viewModel.didTapOnTweetAnnotationView(withViewData: tweetPinAnnotationViewData)
    } // end func
}

//MARK: - Tweet
extension VisualizerViewController : TWTRTweetViewDelegate {
    
    func showTweetView(withTweetObject tweetObject : TWTRTweet) {
        
        // show tweet view
        TweetView.show(onView: self.view, withTweetObject: tweetObject)
    } // end func
}


//MARK: - Error
extension VisualizerViewController {
    
    func displayNotAuthorizedLocationError() {
        
        // display an alert
        self.showAlertWithSettingsButton(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Please tap on Settings and authorize the app to acquire your current location", comment: "Please tap on Settings and authorize the app to acquire your current location"), cancelButtonTitle: NSLocalizedString("Cancel", comment: "Cancel"), cancelButtonHandler: nil)
    }
    
    func displayError(_ error: Error) {
        
        // display an alert
        self.showAlert(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription, buttonTitle: NSLocalizedString("OK", comment: "OK"), buttonHandler: nil)
    }
}

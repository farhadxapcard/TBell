//
//  VisualizerViewModel.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation
import MapKit
import PromiseKit
import PMKCoreLocation
import TwitterKit
import TwitterCore

class VisualizerViewModel {
    
    //MARK: - Public Properties
    weak var viewDelegate : VisualizerViewModelViewDelegate?
    
    //MARK: - Properties Tweets
    private var geoTweets : [GeoTweet] = []
    
    //MARK: - Properties Map
    
    /// Points to current location coordinate, if location is unknown, it will be nil.
    private var currentLocationCoordinate: CLLocationCoordinate2D?
    
    //MARK: - Properties Radius
    
    /// Radiuses user can choose to search around the current location. It's in km.
    lazy private var radiuses : [Int] = [5,10,15,20]
    
    /// Index of the radiuses array that user is selected
    private var selectedRadius : Int {
        didSet {
            
            guard let selectedRadiusIndex = self.radiuses.firstIndex(of: selectedRadius) else {
                return
            }
            
            // inform viewcontroller to set radius segment
            self.viewDelegate?.setSelectedRadiusSegmentIndex(to: selectedRadiusIndex)
            
            // inform viewcontroller to set radius title
            self.viewDelegate?.updateRadiusLabel(to: String.localizedStringWithFormat(NSLocalizedString("Searching in %@ around your current location", comment: "Search in a radius around current location"), self.p_localizedTitle(forRadius: self.selectedRadius)))
            
        } // end didset
    }
    
    private lazy var radiusFormatter : MeasurementFormatter = {
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.roundingMode = .halfUp
        formatter.numberFormatter.maximumFractionDigits = 0
        
        return formatter
    }()
    
    //MARK: - Private Properties
    weak private var coordinator : CoordinatorProtocol?
    private let user : User
    
    //MARK: - Init
    init(coordinator : CoordinatorProtocol, user : User) {
        self.user = user
        self.coordinator = coordinator
        self.selectedRadius = 0
    }
}

//MARK: - VisualizerViewModelProtocol
extension VisualizerViewModel : VisualizerViewModelProtocol {
    
    func start() {
        
        // set the radius segment titles
        self.viewDelegate?.setRadiusSegmentTitles(to: self.radiuses.map {self.p_localizedTitle(forRadius: $0)})
        
        // select the first radius
        self.selectedRadius = self.radiuses[0]
        
        // get current location and fetch tweets around it
        self.p_getCurrentLocationAndFetchTweets(forRadius: self.selectedRadius)
        
    } // end func
    
    func didTapBackButton() {
        
        // informs coordinator to dismiss
        self.coordinator?.finish()
    }
}

//MARK: - Tweet
extension VisualizerViewModel {
    
    func didTapOnTweetAnnotationView(withViewData viewData: TweetPinAnnotationViewDataProtocol) {
        
        guard let tweetObject = (viewData as? GeoTweet)?.tweetObject else {
            return
        }
        
        // login to twitter
        self.user.networkService.loginToTwitter().done { _ in
            
            // ask viewcontroller to show the tweet view
            self.viewDelegate?.showTweetView(withTweetObject: tweetObject)
            
        }.catch { error in
            
            // show the error
            self.viewDelegate?.displayError(error)
        }
    } // end func
    
    /// Gets the current location and fetches the tweets around that location in specified radius.
    private func p_getCurrentLocationAndFetchTweets(forRadius radius : Int) {
        
        firstly { () -> Promise<CLLocationCoordinate2D> in
            
            // get the current location
            self.p_getCurrentLocation()
            
        }.then { coordinate -> Promise<[GeoTweet]> in
            
            // get tweets around the location. since Twitter API requires a query we pass "a" to fulfill that requirement.
            return self.user.networkService.fetchTweets(withSearchText: "a", aroundLocationWithCoordinates: coordinate, withRadius: radius)
            
        }.done { geoTweets in
            
            // update properies
            self.geoTweets = geoTweets
            
            // if no tweet is received, show an alert to user
            guard !geoTweets.isEmpty else {
                
                self.viewDelegate?.showAlertNoTweetsFound()
                return
            }
            
            // show tweets on the map
            self.viewDelegate?.showGeoTweetsOnMap(geoTweets)
            
        }.catch { error in
            
            // if error is due not having location authorization
            if error is LocationError {
                
                self.viewDelegate?.displayNotAuthorizedLocationError()
            }
                // other errors
            else {
                self.viewDelegate?.displayError(error)
            }
        } // end catch
    } // end func
}

//MARK: - Radius
extension VisualizerViewModel {
    
    func didSelectRadiusSegment(atIndex index: Int) {
        
        // update property
        self.selectedRadius = self.radiuses[index]
        
        // get current location and fetch tweets around it
        self.p_getCurrentLocationAndFetchTweets(forRadius: self.selectedRadius)
    } // end func
    
    /// Returns localized title for a radius. Radius is in KM.
    private func p_localizedTitle(forRadius radius : Int) -> String {
        
        let radiusKm = Measurement(value: Double(radius), unit: UnitLength.kilometers)
        return self.radiusFormatter.string(from: radiusKm)
    }
}

//MARK: - Location
private extension VisualizerViewModel {
    
    /// Try to get the current location and updates the coordinate property. If acquiring location was successful, it sets the map region as well.
    /// If failed (for example app doesn't have authorization) return LocationError
    func p_getCurrentLocation() -> Promise<CLLocationCoordinate2D> {
        
        return Promise { seal in
            firstly {
                
                // get authorization
                CLLocationManager.requestAuthorization(type: .whenInUse)
                
            }.then(on: DispatchQueue.main) { _ in
                
                // get the current location
                CLLocationManager.requestLocation(authorizationType : .whenInUse).lastValue
            }.done { location in
                
                // retain the location coordinate
                self.currentLocationCoordinate = location.coordinate
                
                // inform viewcontroller to set map region
                
                // get the diameter in meters
                let diameter = Double(self.selectedRadius) * 2.0 * 1000.0
                
                self.viewDelegate?.setMapRegion(to: MKCoordinateRegion(center: location.coordinate, latitudinalMeters: diameter, longitudinalMeters: diameter))
                
                seal.fulfill(location.coordinate)
                
            }.catch { error in
                
                seal.reject(LocationError.notAuthorized)
            } // end catch
        } // end promise
    } // end func
}



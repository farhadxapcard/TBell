//
//  VisualizerViewModelProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Exposes methods to  VisualizerViewController.
protocol VisualizerViewModelProtocol {
    
    /// Allows viewmodel to send messages to viewcontroller.
    var viewDelegate : VisualizerViewModelViewDelegate? { get set }
    
    /// Starts the viewmodel.
    func start()
    
    /// Informs viewmodel that user tapped Back Button.
    func didTapBackButton()
    
    //MARK: - Radius
    
    /// Informs viewmodel that user selected a new index in radius segment control.
    func didSelectRadiusSegment(atIndex index : Int)
    
    //MARK: - Tweet
    
    /// Informs viewmodel that user tapped on a tweet pin.
    func didTapOnTweetAnnotationView(withViewData viewData : TweetPinAnnotationViewDataProtocol)
}

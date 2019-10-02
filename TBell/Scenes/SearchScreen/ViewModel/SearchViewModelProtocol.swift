//
//  SearchViewModelProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Exposes methods to  SearchViewController.
protocol SearchViewModelProtocol {
    
    ///Allows viewmodel to send messages to viewcontroller
    var viewDelegate : SearchViewModelViewDelegate? { get set }
    
    /// Starts the viewmodel.
    func start()
    
    /// Informs viewmodel that user tapped VisualizerButton.
    func didTapDataVisualizerButton()
    
    //MARK: - Search
    
    /// Inform viewmodel that user changed the searchbar's text.
    func didChangeSearchBarText(to newText : String)
}

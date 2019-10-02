//
//  SearchViewModel.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation
import TwitterKit
import TwitterCore

fileprivate struct Constants {
    
    /// Allow 1 second delay before performing the search
    static let searchDelay : TimeInterval = 1.0
}


class SearchViewModel {
    
    //MARK: - Public Properties
    weak var viewDelegate : SearchViewModelViewDelegate?
    
    //MARK: - Private Properties
    weak private(set) var coordinator : SearchScreenCoordinatorProtocol?
    private let user : User
    
    //MARK: - Properties Search
    
    /// Allow a little delay before performing the search to improve performance
    private var currentSearchWorkItem : DispatchWorkItem?
    
    //MARK: - Init
    init(coordinator : SearchScreenCoordinatorProtocol, user : User) {
        
        self.user = user
        self.coordinator = coordinator
    }
}

//MARK: - SearchViewModelProtocol
extension SearchViewModel : SearchViewModelProtocol {
    
    func start() {
        
        // create a datasource and pass it to viewcontroller
        let datasource = TWTRSearchTimelineDataSource(searchQuery: "", apiClient: self.user.networkService.twitterApiClient)
        
        self.viewDelegate?.refreshTwitterTimelineViewController(withDataSource: datasource)
    } // end func
    
    func didTapDataVisualizerButton() {
        
        // navigate to Visualizer Screen
        self.coordinator?.gotoVisualizerScreen()
    }
}

//MARK: - Search
extension SearchViewModel {
    
    func didChangeSearchBarText(to newText: String) {
        
        let trimmedNewText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // we allow 1 second delay before performing the search to improve performance
        
        // cancel previous search operation
        self.currentSearchWorkItem?.cancel()
        self.currentSearchWorkItem = nil
        var dispatchWorkItem : DispatchWorkItem!
        dispatchWorkItem = DispatchWorkItem() {[weak self] in
            
            guard let self = self else {
                return
            }
            
            if !dispatchWorkItem.isCancelled {
                
                // create a datasource and pass it to viewcontroller
                let datasource = TWTRSearchTimelineDataSource(searchQuery: trimmedNewText, apiClient: self.user.networkService.twitterApiClient)
                
                self.viewDelegate?.refreshTwitterTimelineViewController(withDataSource: datasource)
            }  // end if
        } // end closure
        
        self.currentSearchWorkItem = dispatchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.searchDelay, execute: dispatchWorkItem)
        
    } // end func
}

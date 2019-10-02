//
//  SearchViewController.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

class SearchViewController : UIViewController {
    
    //MARK: - Public Properties
    var viewModel : SearchViewModelProtocol! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    //MARK: - Properties ContainerView
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    //MARK: - Properties TwitterTimelineViewController
    private var twitterTimelineViewController : TWTRTimelineViewController {
        return self.children.first as! TWTRTimelineViewController
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        
 
        // create twitterTimelineViewController and add it as our child
        let twitterTimelineViewController = TWTRTimelineViewController(dataSource: nil)
        twitterTimelineViewController.loadViewIfNeeded()
        
        twitterTimelineViewController.willMove(toParent: self)
        
        let childView = twitterTimelineViewController.view!
        let parentView = self.containerView!
        self.containerView.addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: parentView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        
        self.addChild(twitterTimelineViewController)
        twitterTimelineViewController.didMove(toParent: self)
        
        // start viewmodel
        self.viewModel.start()
    } // end func
}

//MARK: - Button Actions
extension SearchViewController {
    
    /// Gets called when user taps on DataVisualizer Button.
    @IBAction func btnDataVisualizerTapped(_ sender : UIBarButtonItem) {
        self.viewModel.didTapDataVisualizerButton()
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.didChangeSearchBarText(to: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - Search
extension SearchViewController : SearchViewModelViewDelegate {
    
    func refreshTwitterTimelineViewController(withDataSource dataSource: TWTRSearchTimelineDataSource) {
        
        self.twitterTimelineViewController.dataSource = dataSource
    }
}

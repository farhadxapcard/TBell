//
//  SearchViewModelViewDelegate.swift
//  TBell
//
//  Created by Farhad on 2019-10-01.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

/// Allows SearchViewModel to send messages to SearchViewController.
protocol SearchViewModelViewDelegate : class {
    
    func refreshTwitterTimelineViewController(withDataSource dataSource : TWTRSearchTimelineDataSource)
    
}

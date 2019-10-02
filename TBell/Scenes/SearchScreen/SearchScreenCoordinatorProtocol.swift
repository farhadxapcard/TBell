//
//  SearchScreenCoordinatorProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Allows SearchViewModel to send messages to SearchScreenCoordinator.
protocol SearchScreenCoordinatorProtocol : CoordinatorProtocol {
    
    /// Informs coordinator to navigate to Visualizer Screen.
    func gotoVisualizerScreen()
}

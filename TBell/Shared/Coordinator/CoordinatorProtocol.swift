//
//  CoordinatorProtocol.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Allows ViewModels to send messages to Coordinators.
protocol CoordinatorProtocol : class {
    
    /// Informs coordinator that viewmodel is done and dismiss the screen.
    func finish()
}

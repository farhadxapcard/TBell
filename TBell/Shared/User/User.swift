//
//  User.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

/// Represents a user. Services are attached to a user.
class User {
    
    //MARK: - Public Properties
    lazy private(set) var networkService : NetworkServiceProtocol = NetworkService()
    
    //MARK: - Init
    init() {}
}

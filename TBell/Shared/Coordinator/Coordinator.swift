//
//  Coordinator.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

/// Base class for all coordinators.
class Coordinator {
    
    //MARK: - Public Properties
    
    /// Represents an app user.
    let user : User
    lazy private(set) var bundle : Bundle = Bundle(for: type(of: self))
    weak private(set) var parentCoordinator : Coordinator?
    
    //MARK: - Properties Child Coordinator
    private(set) var children : [Coordinator] = []
    
    //MARK: - Init
    init(parentCoordinator : Coordinator?, user : User) {
        self.user = user
        self.parentCoordinator = parentCoordinator
    }
    
    //MARK: - Methods to be Overriden
    
    /// Starts the coordinator. Needs to be override by subclasses.
    func start(animated : Bool) {}
}

//MARK: - Finish Methods
extension Coordinator {
    
    /// Informs parent coordinator that the work of coordinator is finished so parent can remove it from its children coordinators.
    func didFinish() {
        // inform the parent to remove us
        self.parentCoordinator?.remove(child: self)
    }
}

//MARK: - Equatable
extension Coordinator : Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}

//MARK: - Child Coordinator Methods
extension Coordinator {
    
    /// Adds a child coordinator.
    func add(child : Coordinator) {
        self.children.append(child)
    }
    
    /// Removes a child coordinator.
    func remove(child : Coordinator) {
        self.children.removeAll(where: {$0 == child})
    }
}

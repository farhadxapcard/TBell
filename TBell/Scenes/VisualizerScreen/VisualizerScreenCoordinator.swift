//
//  VisualizerScreenCoordinator.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

/// Coordinator for Visualizer Screen.
class VisualizerScreenCoordinator : Coordinator {
    
    //MARK: - Private Methods
    weak private var rootNavigationController : UINavigationController?
    lazy private var storyboard = UIStoryboard(name: "VisualizerScreen", bundle: self.bundle)
    
    //MARK: - Init
    init(parentCoordinator : Coordinator, rootNavigationController : UINavigationController, user: User) {
        
        self.rootNavigationController = rootNavigationController
        super.init(parentCoordinator: parentCoordinator, user: user)
    }
    
    //MARK: - Overriden Methods
    override func start(animated : Bool) {
        
        // create viewcontroller
        let viewcontroller : VisualizerViewController = self.storyboard.instantiateViewController()
        
        // create viewmodel
        let viewmodel = VisualizerViewModel(coordinator: self, user: self.user)
        
        // inject viewmodel into viewcontroller
        viewcontroller.viewModel = viewmodel
        
        // push it into root navigation controller
        self.rootNavigationController?.pushViewController(viewcontroller, animated: animated)
    } // end func
}

//MARK: - CoordinatorProtocol
extension VisualizerScreenCoordinator : CoordinatorProtocol {
    
    func finish() {
        
        // pop viewcontroller
        self.rootNavigationController?.popViewController(animated: true)
        
        // let the parent coordinator knows to remove us as its child
        self.didFinish()
    }
}

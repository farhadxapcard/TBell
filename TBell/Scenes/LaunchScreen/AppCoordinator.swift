//
//  AppCoordinator.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

class AppCoordinator : Coordinator {
    
    //MARK: - Public Methods
    lazy private var rootNavigationController : UINavigationController = {
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }()
    
    //MARK: - Private Methods
    private let window : UIWindow
    
    //MARK: - Init
    init(window : UIWindow) {
        self.window = window
        super.init(parentCoordinator: nil, user: User())
    }
    
    //MARK: - Overriden Methods
    override func start(animated : Bool) {
        
        // configure window
        self.window.rootViewController = self.rootNavigationController
        self.window.makeKeyAndVisible()
        
        /*
         // create search screen coordinator and add it as our child
         let searchCoordinator = SearchScreenCoordinator(parentCoordinator: self, rootNavigationController: self.rootNavigationController, user: self.user)
         self.add(child: searchCoordinator)
         
         // start it
         searchCoordinator.start(animated: false)
         */
        
        
        // create VisualizerScreen coordinator
        let visualizerScreenCoordinator = VisualizerScreenCoordinator(parentCoordinator: self, rootNavigationController: rootNavigationController, user: self.user)
        self.add(child: visualizerScreenCoordinator)
        
        // start it
        visualizerScreenCoordinator.start(animated: false)
        
    } // end func
}

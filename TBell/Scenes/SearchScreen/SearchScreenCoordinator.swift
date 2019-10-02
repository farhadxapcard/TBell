//
//  SearchScreenCoordinator.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

/// Coordinator for Search Screen.
class SearchScreenCoordinator : Coordinator {
    
    //MARK: - Private Methods
    weak private var rootNavigationController : UINavigationController?
    lazy private var storyboard = UIStoryboard(name: "SearchScreen", bundle: self.bundle)
    
    //MARK: - Init
    init(parentCoordinator : Coordinator, rootNavigationController : UINavigationController, user : User) {
        
        self.rootNavigationController = rootNavigationController
        super.init(parentCoordinator: parentCoordinator, user: user)
    }
    
    //MARK: - Overriden Methods
    override func start(animated : Bool) {
        
        // create viewcontroller
        let viewcontroller : SearchViewController = self.storyboard.instantiateViewController()
        
        // create viewmodel
        let viewmodel = SearchViewModel(coordinator: self, user: self.user)
        
        // inject viewmodel into viewcontroller
        viewcontroller.viewModel = viewmodel
        
        // push it into root navigation controller
        self.rootNavigationController?.pushViewController(viewcontroller, animated: animated)
    } // end func
}

//MARK: - SearchScreenCoordinatorProtocol
extension SearchScreenCoordinator : SearchScreenCoordinatorProtocol {
    
    func finish() {
        
        // pop viewcontroller
        self.rootNavigationController?.popViewController(animated: true)
        
        // let the parent coordinator knows to remove us as its child
        self.didFinish()
    }
    
    func gotoVisualizerScreen() {
        
        guard let rootNavigationController = self.rootNavigationController else {
            return
        }
        
        // create VisualizerScreen coordinator
        let visualizerScreenCoordinator = VisualizerScreenCoordinator(parentCoordinator: self, rootNavigationController: rootNavigationController, user: self.user)
        self.add(child: visualizerScreenCoordinator)
        
        // start it
        visualizerScreenCoordinator.start(animated: true)
    } // end func
}

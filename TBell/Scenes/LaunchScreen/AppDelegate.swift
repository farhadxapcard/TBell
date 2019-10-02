//
//  AppDelegate.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import PromiseKit
import TwitterKit
import TwitterCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Public Properties
    private(set) var appCoordinator : AppCoordinator!
    
    //MARK: - Lifecycle Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // configure promisekit queues
        conf.catchPolicy = .allErrorsExceptCancellation
        conf.Q = (map: DispatchQueue.global(qos: .default), return: DispatchQueue.main)
        
        // configure twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey: twitterApiKey, consumerSecret: twitterApiSecretKey)
        
        // create window
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create App Coordinator and start it
        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start(animated: false)
        
        return true
    } // end func
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}


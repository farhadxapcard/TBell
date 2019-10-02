//
//  UIViewController+ShowAlert.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias ButtonHandler = (UIAlertAction) -> Void
    
    /// Displays an alert with 2 buttons which one is "Settings" and the other one is "Cancel" or any other button on current viewcontroller.
    /// settingsButtonAdditionalHandler closure will be executed after the user taps on Settings button and the app redirects the user to Device Settings. It is used if for example viewcontroller wants to dismiss itself after user taps on Settings button.
    func showAlertWithSettingsButton(title : String?, message : String?, cancelButtonTitle : String, cancelButtonHandler :  ButtonHandler?, settingsButtonAdditionalHandler : (() -> Void)? = nil) {
        
        let btnSettings = UIAlertAction(title: NSLocalizedString("Settings", comment: "App Settings"), style: .default) { _ in
            
            defer {
                settingsButtonAdditionalHandler?()
            }
            
            // open app settings
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) else {
                return
            }
            
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } // end handler
        
        let btnCancel = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelButtonHandler)
        
        self.showAlert(title: title, message: message, actions: [btnSettings,btnCancel])
        
    } // end func
    
    /// Displays an alert with one button on current viewcontroller.
    func showAlert(title : String?, message : String?, buttonTitle : String, buttonHandler : ButtonHandler?) {
        
        let button = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        
        self.showAlert(title: title, message: message, actions: [button])
        
    } // end func
    
    /// Displays an alert with multiple buttons on current viewcontroller.
    func showAlert(title : String?, message : String?, actions : [UIAlertAction]) {
        
        let alertVC = p_createAlertController(title: title, message: message)
        
        for action in actions {
            alertVC.addAction(action)
        }
        
        self.present(alertVC, animated: true, completion: nil)
        
    } // end func
} // end extension

private extension UIViewController {
    
    /// Creates an alert controller with title and message.
    func p_createAlertController(title : String?, message : String?) -> UIAlertController {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.modalPresentationStyle = .overCurrentContext
        
        return alertVC
    }
}


//
//  UIStoryboard+InstantiateVC.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// Creates a ViewController with an identifier same as the class's name.
    func instantiateViewController<VC : UIViewController>() -> VC {
        
        return self.instantiateViewController(withIdentifier: String(describing: VC.self)) as! VC
    }
}

//
//  UIViewController+LoadFromNib.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Loads a viewcontroller from a NIB file.
    /// nibFileName points to the NIB file name. If nil, the method assumes the name of the filename and class is the same.
    class func loadFromNib<U : UIViewController>(nibFileName : String? = nil) -> U {
        
        let name = nibFileName ?? String(describing: self)
        return U(nibName: name, bundle: Bundle(for: self))
    }
}



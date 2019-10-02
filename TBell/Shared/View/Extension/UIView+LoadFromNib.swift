//
//  UIView+LoadFromNib.swift
//  TBell
//
//  Created by Farhad on 2019-10-01.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Load a view from NIB file.
    /// nibFileName points to the NIB file name. If nil, the method assumes the name of the filename and class is the same.
    class func loadFromNib<U : UIView>(owner : Any? = nil, nibFileName : String? = nil) -> U {
        
        let name = nibFileName ?? String(describing: self)
        
        return Bundle(for: self).loadNibNamed(name, owner: owner, options: nil)?.first! as! U
    }
}


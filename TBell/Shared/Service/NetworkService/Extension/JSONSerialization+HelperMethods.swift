//
//  JSONSerialization+HelperMethods.swift
//  TBell
//
//  Created by Farhad on 2019-09-30.
//  Copyright © 2019 Farhad. All rights reserved.
//

import Foundation

extension JSONSerialization {
    
    /// Converts a dictionary to a json. If the conversation fails, returns nil.
    class func jsonFrom(dictionary : [String:Any]) -> Data? {
        
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: [])
        } catch {
            
            assertionFailure("Cannot convert \(dictionary) to json because \(error)")
            return nil
        }
    } // end func
    
    /// Converts a json to a dictionary. If the conversation fails, returns nil.
    class func dictionary(fromJson json : Data) -> [String:Any]? {
        
        do {
            return try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String : Any]
        } catch {
            
            assertionFailure("Cannot convert \(json) to dictionary because \(error)")
            return nil
        }
    } // end func
    
    /// Converts a json to an array. If the conversation fails, returns nil.
       class func array(fromJson json : Data) -> [Any]? {
           
           do {
               return try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [Any]
           } catch {
               
               assertionFailure("Cannot convert \(json) to array because \(error)")
               return nil
           }
       } // end func
}

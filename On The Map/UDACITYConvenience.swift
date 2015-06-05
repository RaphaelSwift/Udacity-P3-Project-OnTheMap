//
//  UDACITYConvenience.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 02.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit
import Foundation

// MARK: Convenient Resource Methods

extension UDACITYClient {
    
    func createSessionWithUdacity (username: String, password: String, completionHandler: ( sessionCreated : Bool, error: String? ) -> Void ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody: [String:[String:AnyObject]] = [JSONBodyKeys.Udacity:[
            JSONBodyKeys.Username : username ,
            JSONBodyKeys.Password : password
        ]]
        
        /* 2. Make the request */
        taskForPOSTMethod(UDACITYClient.Methods.Session, jsonBody: jsonBody) { result, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if error.code == -1001 { // request timed out
                    completionHandler(sessionCreated: false, error: "TimedOut")
        
                } else {
                    completionHandler(sessionCreated: false, error: "PostFailed")
                }
            } else {
                
                if let sessionResult = result[UDACITYClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                    if let sessionID = sessionResult[JSONResponseKeys.SessionID] as? String {
                        completionHandler(sessionCreated: true, error: nil)
                        self.sessionID = sessionID
                        
                    } else {
                        completionHandler(sessionCreated: false, error: "Unable to get a session ID")
                    }
                } else {
                    if let statusCode = result[JSONResponseKeys.Status] as? Int {
                        if statusCode == 403 || statusCode == 400 { //  Account not found or invalid credentials
                            completionHandler(sessionCreated: false, error: "AccountNotFoundOrInvalidCredentials")
                        } else {
                            completionHandler(sessionCreated: false, error: "Unknown status code")
                        }
                    }
                
                }
            }
            
            
            }
        
        
    }
    
    
    func createSessionWithFacebook(facebookAccessToken: String, completionHandler: (sessionCreated: Bool, error: String?)->Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody: [String:[String:AnyObject]] = [
            JSONBodyKeys.Facebook :
                [ JSONBodyKeys.FacebookAccessToken: facebookAccessToken]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(UDACITYClient.Methods.Session, jsonBody: jsonBody) { result, error in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if error.code == -1001 { // request timed out
                    completionHandler(sessionCreated: false, error: "TimedOut")
                    
                } else {
                    completionHandler(sessionCreated: false, error: "PostFailed")
                }
                
            } else {
                if let sessionResult = result[UDACITYClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                    if let sessionID = sessionResult[JSONResponseKeys.SessionID] as? String {
                        completionHandler(sessionCreated: true, error: nil)
                        self.sessionID = sessionID
                    } else {
                        completionHandler(sessionCreated: false, error: "failed to create a session createSessionWithFacebook - taskForPOSTMethod")
                    }
                }
            }
            
            }
        
        
    }
    
}

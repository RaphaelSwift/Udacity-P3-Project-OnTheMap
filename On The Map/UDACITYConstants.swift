//
//  UDACITYConstants.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 02.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

extension UDACITYClient {
    
    //MARK: - Constants
    
    struct Constants {
    
        //MARK : URL
        
        static let baseSecureURL = "https://www.udacity.com/api/"
        
    }
    
    //MARK: - Methods
    struct Methods {
        
        //MARK: - Session
        static let Session = "session"
        
    }
    
    //MARK: - JSON Body Keys
    
    struct JSONBodyKeys {
        
        static let FacebookAccessToken = "access_token"
        static let Facebook = "facebook_mobile"
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"

    }
    
    
    //MARK: - JSON Response Keys
    
    struct JSONResponseKeys {
        
        static let Session = "session"
        static let SessionID = "id"

    }
    
}
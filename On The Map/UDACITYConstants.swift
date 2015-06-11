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
        static let User = "users/<user_id>"
        
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
        
        static let Account = "account"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Key = "key"
        static let Status = "status"
        static let Session = "session"
        static let SessionID = "id"
        static let User = "user"

    }
    
    //MARK: - URL Keys
    
    struct URLKeys {
        
        static let UserId = "user_id"
        
    }
    
}
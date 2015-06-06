//
//  PARSEConstants.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 06.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import Foundation

extension PARSEClient {
    
    
    
    //MARK: Constants
    
    struct Constants {
        
        //MARK Keys
        
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //MARK: URLs
        
        static let BaseSecureURL = "https://api.parse.com/1/classes/"
        
        
    }
    
    
    //MARK: Methods
    
    struct Methods {
    
        static let StudentLocations = "StudentLocation"
        
    }
    
    //MARK: JSON Response Keys
    
    struct JSONResponseKeys {
    
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let Results = "results"
        
    }
    
}
//
//  PARSEStudentInformation.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 06.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import Foundation


struct PARSEStudentInformation {

    var objectId = ""
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    
    // Construct a PARSESStudentInformation from a dictionary
    
    init(dictionary: [String : AnyObject ]) {
        
        objectId = dictionary [PARSEClient.JSONResponseKeys.ObjectID] as! String
        firstName = dictionary[PARSEClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[PARSEClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[PARSEClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[PARSEClient.JSONResponseKeys.Longitude] as? Double
        mapString = dictionary[PARSEClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[PARSEClient.JSONResponseKeys.MediaURL] as? String
    
    }
    
    
    // Helper: Given an array of dictionnaries, convert them to an an array of type PARSEStudentInformation
    
    static func studentsFromResults(results: [[String: AnyObject]]) -> [PARSEStudentInformation] {
        
        var students = [PARSEStudentInformation]()
        
        for result in results {
            
            students.append(PARSEStudentInformation(dictionary: result))
            
        }
                
        return students
        
    }
    
    
}
//
//  PARSEConvenience.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 06.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit
import Foundation


// MARK: Convenient Resource Methods

extension PARSEClient {
    
    
    
    func loadStudentsInformation(completionHandler: (success: Bool, error: String?) -> Void) {
        
        self.getStudentsInformation { students, error in
            
            if let students = students {
                self.studentsInformation = students
                completionHandler(success: true, error: nil)
                
            } else {
                completionHandler(success: false, error: error)
                
            }
            
        }
    }
    
    
    
    func getStudentsInformation(completionHandler : (result: [PARSEStudentInformation]?, error: String?)->Void) {
        
        /* 1. Specify the parameters */
        let method = Methods.StudentLocations
        
        /* 2. Make the request*/
        taskForGETMethod(method) { parsedData, error in
            
            /* 3. Send the desired values to the completion handler */
            if let error = error {
                completionHandler(result: nil, error: error.localizedDescription)
                
            } else {
                
                if let parsedData = parsedData[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    var students = PARSEStudentInformation.studentsFromResults(parsedData)
                    completionHandler(result: students, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: "Unable to find value for key: \(JSONResponseKeys.Results) or unable to downcast to desired format")
                }
            }
        }
    }

    
    func addStudentLocation(latitude: Double, longitude: Double, mapString: String, mediaUrl: String, completionHandler: (success: Bool, error: String?) -> Void ) {
        
        /* 1. Specify the parameters */
        let method = Methods.StudentLocations
        
        let jsonBodyParamaters: [String: AnyObject] = [
            JSONBodyParamaters.UniqueKey :UDACITYClient.sharedInstance().userID!,
            JSONBodyParamaters.FirstName : UDACITYClient.sharedInstance().userFirstName!,
            JSONBodyParamaters.LastName : UDACITYClient.sharedInstance().userLastName!,
            JSONBodyParamaters.MediaURL : mediaUrl,
            JSONBodyParamaters.MapString : mapString,
            JSONBodyParamaters.Latitude : latitude,
            JSONBodyParamaters.Longitude : longitude
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, jsonBodyParameters: jsonBodyParamaters) { parsedResult, error in
            
            if let error = error {
                completionHandler(success: false, error: error.localizedDescription)
                
            } else {
              
                if let parsedData = parsedResult[JSONResponseKeys.CreatedAt] as? String {
                    completionHandler(success: true, error: nil)
                    
                } else {
                    completionHandler(success: false, error: " Could not find key : \(JSONResponseKeys.CreatedAt) in parsedResult, method : addStudentLocation/taskForPOSTMethod ")
        
                }
                
            }
            
        }
        
        
        
    }
    
    
}
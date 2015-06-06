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
    
    
    func getStudentsInformation(completionHandler : (result: [PARSEStudentInformation]?, error: String?)->Void) {
        
        /* 1. Specify the parameters */
        let method = Methods.StudentLocations
        
        /* 2. */
        taskForGETMethod(method) { parsedData, error in
            
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
    
}
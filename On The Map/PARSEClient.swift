//
//  PARSEClient.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 06.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import Foundation

class PARSEClient: NSObject {
    
    /* Students Data */
    
    var studentsInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()

    /* Shared Session */
    var session: NSURLSession
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    //MARK: - GET
    
    func taskForGETMethod(method: String, completionHandler:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        /* 1. Set the parameters */
        
        
        /* 2. Build the URL */
        
        let urlString = Constants.BaseSecureURL + method
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        
        let task = session.dataTaskWithRequest(request) { result, response, downloadError in
        
            /* 5/6. Parse the data and use the data ( happens in the completion handler) */
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                self.parseDataWithJSONWithCompletionHandler(result, completionHandler: completionHandler)
                
            }
        
        }
        
        /* 7. Start the task */
        
        task.resume()
        
        return task
        
        
    }
    
    
    //MARK: - POST
    
    func taskForPOSTMethod(method: String, jsonBodyParameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?)->Void) -> NSURLSessionTask {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        let urlString = Constants.BaseSecureURL + method
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBodyParameters, options: nil, error: &jsonifyError)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* 5/6. Parse the data and use the data (happens in the completion handler) */
            if let error = error {
                println(error.localizedDescription)
                completionHandler(result: nil, error: error)
                
            } else {
                self.parseDataWithJSONWithCompletionHandler(data, completionHandler: completionHandler)
                
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
        return task
        
    }
    
    //MARK: -  Helpers
    
    //Helper Function : Given a raw JSON Data set, return an usable Foundation object
    
    func parseDataWithJSONWithCompletionHandler (data: NSData!, completionHandler: (result: AnyObject!, error: NSError?)-> Void ) {
        
        var parsedError: NSError? = nil
        
        let parsedData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError)
        
        if let error = parsedError {
            completionHandler(result: nil, error: error)
            
        } else {
            completionHandler(result: parsedData, error: nil)
            
        }
        
        
    }
    
    

    
    
    // Shared Instance
    
    class func SharedInstance() -> PARSEClient {
        
        struct Singleton {
            static var sharedInstance = PARSEClient()
        }
    
    return Singleton.sharedInstance
    
    }
    
    
    
}
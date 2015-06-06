//
//  PARSEClient.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 06.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import Foundation

class PARSEClient: NSObject {

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
        
        let urlString = Constants.BaseSecureURL + Methods.StudentLocations
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
    
    //Helper Functions : Given a raw JSON Data set, return an usable Foundation object
    
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
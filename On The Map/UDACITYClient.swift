//
//  UDACITYClient.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 02.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import Foundation

class UDACITYClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    
    var sessionID: String? = nil

    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // Mark: - POST
    
    func taskForPOSTMethod(method: String, jsonBody: [String:[String:AnyObject]], completionHandler:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        /* 1. Set The parameters */
        
        
        
        /* 2/3. Build the URL and configure the request */
        let urlString = UDACITYClient.Constants.baseSecureURL + UDACITYClient.Methods.Session
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            /* 5/6 Parse the data and use the data (happens in the complention handler) */
            if let error = downloadError {
                println("unable to download data taskForPostMethod")
                println(error)
                completionHandler(result: nil, error: error)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5 )) // Subset response data!
                self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        
        
        }
        /* 7. Start the request*/
        task.resume()
        
        return task
    
 }

    // Helper function : Given raw JSON  data set, return an usable Foundation object
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) ->Void) {
        
        var parsedError:NSError? = nil
        
        
        if let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError) as? [String:AnyObject] {
            println(parsedData)
            
            if let error = parsedError {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: parsedData, error: nil)
            }
            
        } else {
            println("Could not parse data")
        }
        
    }
    
    // Singleton - Shared instance
    
    class func sharedInstance() -> UDACITYClient {
        struct Singleton {
            static var sharedInstance = UDACITYClient()
        }
        
     return Singleton.sharedInstance
    }
    
    
    
}
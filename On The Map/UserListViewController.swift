//
//  UserListViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 04.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var studentsTableView: UITableView!
    
    //MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the navigation bar buttons
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
        let rightBarButtonItemRefresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "loadAndDisplayStudentData")
        
        let pinImage = UIImage(named: "Pin")!
        let rightBarButtonItemAddUserLocation = UIBarButtonItem(image: pinImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addUserLocationButtonTouchUp")
        self.parentViewController!.navigationItem.rightBarButtonItems = [rightBarButtonItemRefresh,rightBarButtonItemAddUserLocation]
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadAndDisplayStudentData()
        

    }
    
    
    //MARK: UserListViewController
    
    func loadAndDisplayStudentData() {
        
        self.activityIndicator.startAnimating()
        
        PARSEClient.SharedInstance().loadStudentsInformation() { success , error in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue()) {
                    //Reload the tableview
                    self.studentsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                
                if error! == "The request timed out." {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayNetworkAlert()
                        
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayDownloadFailureAlert(error!)
                    }
                }
            }

            
        }
    }
    
    
    func logoutButtonTouchUp() {
        
        UDACITYClient.sharedInstance().logoutUdacity() { success, error in
            if success {
                
                // Logout of our current Facebook session as well
                
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } else {
                println(error)
            }
        }
    }

    
    func addUserLocationButtonTouchUp() {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PARSEClient.SharedInstance().studentsInformation.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let student = PARSEClient.SharedInstance().studentsInformation[indexPath.row]
        
        let cell = studentsTableView.dequeueReusableCellWithIdentifier("StudentListTableViewCell") as! UITableViewCell

        
        /* Set cell defaults */
        cell.textLabel?.text = " \(student.firstName!) \(student.lastName!)"
        cell.imageView?.image = UIImage(named: "Pin")
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = PARSEClient.SharedInstance().studentsInformation[indexPath.row]
        
        if let studentLink = student.mediaURL {
            
            if let nsurl = NSURL(string: studentLink) {
                
                /* Open the default device browser to the student link */
                UIApplication.sharedApplication().openURL(nsurl)
            }
            
            
        }
        
    }

    //MARK: UIAlertController
    
    func displayNetworkAlert() {
        
        let alertController = UIAlertController(title: "Download Failed", message: "Network unavailable or network error occured. Please check your internet connection and retry", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionRetry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { action in
            
            self.loadAndDisplayStudentData()
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
            
            self.activityIndicator.stopAnimating()
            
        }
        
        alertController.addAction(actionRetry)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func displayDownloadFailureAlert(error: String) {
        
        let alertController = UIAlertController(title: "Download Failed", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

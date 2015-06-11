//
//  ViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 02.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var udacityImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Check if the user is already logged in, if yes, complete login to Udacity
        if FBSDKAccessToken.currentAccessToken() != nil  {
            loginToUdacityWithFacebookSessionID()

        }
        

        
        // By default hides the activity indicator when it is stopped.
        self.activityIndicator.hidesWhenStopped = true
        

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.udacityImageView.image = UIImage(named: "Udacity")
        
        // Create the Facebook Login button view and position it at bottom of the screen
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = CGPointMake(self.view.center.x, self.view.frame.height - 40)
        loginView.delegate = self
        
    }
    

    
    
    //MARK: - Actions
    
    
    @IBAction func loginWithUdacityTouchUpInside() {
        
        self.activityIndicator.startAnimating()
        
        loginToUdacityWithUdacityCredentials()


    }

    @IBAction func signUpToUdacityTouchUpInside() {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
 
    }

    
    //MARK: - LoginViewController
    
    func loginToUdacityWithUdacityCredentials() {
        
        UDACITYClient.sharedInstance().createSessionWithUdacity(self.emailTextField.text, password: self.passwordTextField.text) { success, error in
            if let error = error {
                if error == "TimedOut"
                {
                    self.displayAlertRequestTimedOut()
                    
                } else if error == "AccountNotFoundOrInvalidCredentials" {
                    
                    self.displayAlertAccountNotFoundOrInvalidCredentials()
                    
                } else if error == "PostFailed" {
                    self.displayAlertPostFailed(false)
                }
                
                println(error)
            } else {
                if success {
                    
                    self.completeLogin()
                }
            }
            
        }
        
    }
    
    
    func loginToUdacityWithFacebookSessionID () {
        
        self.activityIndicator.startAnimating()
        
        let token = FBSDKAccessToken.currentAccessToken().tokenString
        UDACITYClient.sharedInstance().createSessionWithFacebook(token) { success, error in
            if success {
                self.completeLogin()
                
            } else {
                if let error = error {
                    if error == "TimedOut"
                    {
                        self.displayAlertRequestTimedOut()
                        
                    } else if error == "PostFailed" {
                        self.displayAlertPostFailed(true)
                    }
                    
                }
                
                
            }
            
        }
    }
    
    
    func completeLogin() {
        
        dispatch_async(dispatch_get_main_queue()) {
        
            
            UDACITYClient.sharedInstance().getUserData() { success, error in
                if success {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                
                    self.activityIndicator.stopAnimating()
                    
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                        
                    }
                
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    self.displayUserDataAlert(error!)
                        
                    }
                }
                
            }
        }
    }
    
    
    //MARK: - UIAlertController
    
    // Display an alert if the request times out
    func displayAlertRequestTimedOut() {
        
        dispatch_async(dispatch_get_main_queue()) {
    
    let alertController = UIAlertController(title: "Login Failed", message: "Request timed out, please check your internet connection and retry ", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
            self.activityIndicator.stopAnimating()
            
        }
        
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    // Display an alert if the account is not found or the if credentials are invalid
    func displayAlertAccountNotFoundOrInvalidCredentials() {
        
        dispatch_async(dispatch_get_main_queue()) {
        
    let alertController = UIAlertController(title: "Login Failed", message: "Account not found or invalid credentials", preferredStyle: UIAlertControllerStyle.Alert)
            
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
            self.activityIndicator.stopAnimating()
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
        }
        
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    
        }
    }
    
    // Display an alert if the post fails for a reason which is not due to internet connection and allows the user to retry
    
    func displayAlertPostFailed(FacebookAuthentification: Bool) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
    let alertController = UIAlertController(title: "Server Failure", message: "Could not connect to Udacity server ", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in

                self.activityIndicator.stopAnimating()
                
            }
            
            let actionRetry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { action in
                
                if FacebookAuthentification {
                    self.loginToUdacityWithFacebookSessionID()
                } else {
                    self.loginToUdacityWithUdacityCredentials()
                }
                
                }
            
        alertController.addAction(actionCancel)
        alertController.addAction(actionRetry)
            
        self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func displayUserDataAlert(error: String) {
        
        let alertController = UIAlertController(title: "Download Failed", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Facebook FBSDKLoginButtonDelegate
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            println("Could not login to Facebook , : \(error.localizedDescription)")
            
        } else if result.isCancelled {
            // Handle cancellations
        }
        
        else {
            //TODO: Create session with facebook sesion ID, complete login

            loginToUdacityWithFacebookSessionID()

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.activityIndicator.stopAnimating()
    }
}


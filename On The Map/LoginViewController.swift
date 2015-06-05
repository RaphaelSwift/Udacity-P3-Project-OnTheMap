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
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check if the user is already logged in, if yes, complete login to Udacity
        if FBSDKAccessToken.currentAccessToken() != nil  {
            let token = FBSDKAccessToken.currentAccessToken().tokenString
            UDACITYClient.sharedInstance().createSessionWithFacebook(token) { success, error in
                if success {
                    println("successfully logged to Udacity")
                    self.completeLogin()
                } else {
                    println(error)
                }
                
            }

        } else {
                // Create the Facebook Login button view and position it at bottom of the screen
                let loginView : FBSDKLoginButton = FBSDKLoginButton()
                self.view.addSubview(loginView)
                loginView.center = CGPointMake(self.view.center.x, self.view.frame.height - 40)
                loginView.delegate = self
        }


    }
    
    
    //MARK: - Actions
    
    
    @IBAction func loginWithUdacityTouchUpInside() {
        
        UDACITYClient.sharedInstance().createSessionWithUdacity(emailTextField.text, password: passwordTextField.text) { success, error in
            if let error = error {
                println(error)
            } else {
                if success {
                    println("successfully logged to Udacity")
                    self.completeLogin()
                } else {
                    println(error)
                }
            }
            
        }
        

    }

    @IBAction func signUpToUdacityTouchUpInside() {
    }

    
    //MARK: - LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - Facebook FBSDKLoginButtonDelegate
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            println("Could not login to Facebook , : \(error.localizedDescription)")
            
        } else if result.isCancelled {
            //handle cancellation
            
        } else {
            //TODO: create session with facebook, complete login
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            UDACITYClient.sharedInstance().createSessionWithFacebook(accessToken) { success, error in
                if success {
                    println("successfully logged to Udacity")
                    self.completeLogin()
                } else {
                    println(error)
                }
                
            }

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("logged out")
    }
}


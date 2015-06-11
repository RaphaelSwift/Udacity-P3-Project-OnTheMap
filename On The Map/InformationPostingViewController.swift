//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 09.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController{
    
    
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var geocodeTextField: UITextField!
    @IBOutlet weak var userLocationMapView: MKMapView!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitLocationButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!

    
    var location: CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.promptLabel.hidden = false
        self.geocodeTextField.hidden = false
        self.findOnTheMapButton.hidden = false
        self.userLocationMapView.hidden = true
        self.submitLocationButton.hidden = true
        self.linkTextField.hidden = true
    }
    
    
    //MARK: InformationPostingViewController
    
    
    // Geocode the string entered by the use
    func geocodeSearch(geocodeSearchString: String, completionHandler: (success: Bool, error: NSError?)-> Void) {
    
        
    let CLGeocode = CLGeocoder()
        
        CLGeocode.geocodeAddressString(geocodeSearchString) { placemarks, error in
        
            if let error = error {
                completionHandler(success: false, error: error)
                
            } else {
                let placemarks = placemarks as! [CLPlacemark]

                    self.location = placemarks.first?.location!
                    completionHandler(success: true, error: nil)
            
            }
        }
        
    }
    
    // Check if the geocoding is succesfull and display the location of the user on the map. If it fails, display an alert.
    
    func displayUserLocationOnTheMap () {
        
        
        self.geocodeSearch(geocodeTextField.text!) { success, error in
            if success {
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    self.promptLabel.hidden = true
                    self.geocodeTextField.hidden = true
                    self.userLocationMapView.hidden = false
                    self.activityIndicator.stopAnimating()
                    self.findOnTheMapButton.hidden = true
                    self.submitLocationButton.hidden = false
                    self.linkTextField.hidden = false
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.location!.coordinate
                    
                    self.userLocationMapView.addAnnotation(annotation)
                    self.userLocationMapView.setCenterCoordinate(annotation.coordinate, animated: true)
                    
                }
                
            } else {
                if error?.code == CLError.Network.rawValue {
                    
                    self.displayNetworkAlert()
                    
                } else {
                    
                    self.displayStandardGeocodingAlert()
                }
            }
            
        }
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func cancelButtonTouchUpInside() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func findOnTheMapButtonTouchUpInside(sender: AnyObject) {
        
        self.activityIndicator.startAnimating()
        self.geocodeTextField.enabled = false
        self.geocodeTextField.alpha = 0.5
        self.findOnTheMapButton.enabled = false
        
        self.displayUserLocationOnTheMap()
        
        
    }
    
    @IBAction func submitLocationButtonTouchUpInside() {
        
        if self.linkTextField.text.isEmpty {
            self.displayEmptyLinkAlert()
            
        } else {
            
            let latitude = self.location!.coordinate.latitude
            let longitude = self.location!.coordinate.longitude
            
            
            PARSEClient.SharedInstance().addStudentLocation(latitude, longitude: longitude, mapString: self.geocodeTextField.text, mediaUrl: self.linkTextField.text) { success, error in
                
                if let error = error {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    
                    self.displaySubmitLocationFailureAlert(error)
                        
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.dismissViewControllerAnimated(true, completion: nil)

                        
                    }
                    
                }
                
            }
        }
    }
    

    
    //MARK: - UIAlertController
    
    func displayNetworkAlert() {
        
        let alertController = UIAlertController(title: "Geocoding Failed", message: "Network unavailable or network error occured. Please check your internet connection and retry", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionRetry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { action in
            
            self.displayUserLocationOnTheMap()
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
            
            self.activityIndicator.stopAnimating()
            self.geocodeTextField.enabled = true
            self.geocodeTextField.alpha = 1
            self.findOnTheMapButton.enabled = true
            
        }
        
        alertController.addAction(actionRetry)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func displayStandardGeocodingAlert() {
        
        let alertController = UIAlertController(title: "Geocoding Failed", message: "Could not get result for the named location, please check and retry", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
            
            self.activityIndicator.stopAnimating()
            self.geocodeTextField.enabled = true
            self.geocodeTextField.alpha = 1
            self.findOnTheMapButton.enabled = true
        }
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func displayEmptyLinkAlert() {
        
        let alertController = UIAlertController(title: "Link Empty", message: "Please enter a link", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func displaySubmitLocationFailureAlert(error: String) {
        
        let alertController = UIAlertController(title: "Submission Failure", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

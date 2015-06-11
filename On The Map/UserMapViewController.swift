//
//  UserMapViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 04.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import MapKit
import UIKit
import FBSDKLoginKit

class UserMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    var pinViewSubtitle: String? = nil
    
    
    @IBOutlet weak var studentsLocationMapView: MKMapView!


    
    //MARK: Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create and configure the navigation bar buttons
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
        let rightBarButtonItemRefresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "loadAndDisplayStudentData")
        
        let pinImage = UIImage(named: "Pin")!
        let rightBarButtonItemAddUserLocation = UIBarButtonItem(image: pinImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addUserLocationButtonTouchUp")
        self.parentViewController!.navigationItem.rightBarButtonItems = [rightBarButtonItemRefresh,rightBarButtonItemAddUserLocation]
        
        // set the delegate
        self.studentsLocationMapView.delegate = self
        
        // Initialize the tapRecognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

        
        // fetch the data
        loadAndDisplayStudentData()

        
        
    }


//MARK: Functional stubs for handling UI behaviors
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        
        if let pinViewSubtitle = self.pinViewSubtitle {
            
            
            if let nsurl = NSURL(string: pinViewSubtitle) {
        
                UIApplication.sharedApplication().openURL(nsurl)
            }
            
        }

    }
    
    
//MARK: UserMapViewController
    
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
    
    
    func loadAndDisplayStudentData() {
        
        self.activityIndicator.startAnimating()
        
        PARSEClient.SharedInstance().loadStudentsInformation() { success , error in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue()) {
                    //Reload the tableview
                    self.addStudentsLocation(PARSEClient.SharedInstance().studentsInformation)
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
    
    func addUserLocationButtonTouchUp() {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)

    }

    
    
//MARK: MapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
         /* Try to dequeue an existing pin view first */
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("StudentPin") as? MKPinAnnotationView
        
        /* If an existing pin view was not available, create one. */
        
        if pinView == nil {

            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "StudentPin")
            pinView!.canShowCallout = true
            pinView!.leftCalloutAccessoryView = UIImageView(image: (UIImage(named: "Map")))
            pinView!.pinColor = MKPinAnnotationColor.Purple

            
    
            
        } else {
            
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.pinViewSubtitle = view.annotation.subtitle
        println(self.pinViewSubtitle)
        view.addGestureRecognizer(tapRecognizer!)
        
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        view.removeGestureRecognizer(tapRecognizer!)
    }

 //MARK: MapView
    
    // Add the locations of the students to the map
    func addStudentsLocation(students: [PARSEStudentInformation]) {
        
        var studentsLocationPoint = [MKAnnotation]()
        
        for student in students {
            let point = MKPointAnnotation()

            
            if let latitude = student.latitude {
                
                if let longitude = student.longitude {
                    
                    let studentPoint = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    // Check if the coordinates are valid
                    if CLLocationCoordinate2DIsValid(studentPoint) {
                        
                        //Set the coordinate, title and subtitle
                        point.coordinate = studentPoint
                        point.title = "\(student.firstName!) \(student.lastName!)"
                        point.subtitle = student.mediaURL!
                        
                        //Append our array of students points
                        studentsLocationPoint.append(point)
                        
                        //Add the points to the Map
                        self.studentsLocationMapView.addAnnotations(studentsLocationPoint)
                        
                        
                    }
                }
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

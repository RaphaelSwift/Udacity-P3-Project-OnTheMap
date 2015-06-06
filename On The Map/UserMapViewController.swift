//
//  UserMapViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 04.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import MapKit
import UIKit

class UserMapViewController: UIViewController {
    
    var studentsInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()
    
    var pinView = MKPinAnnotationView()
    var point = MKPointAnnotation()
    
    
    @IBOutlet weak var studentsLocationMapView: MKMapView!

    
    //MARK: Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        PARSEClient.SharedInstance().getStudentsInformation { students, error in
            if let students = students {
                self.studentsInformation = students
                
                //Reload the view
                self.studentsLocationMapView.reloadInputViews()
                
            } else {
                println(error)
            }
            
        }
        
        
        //Set the map region
        let bernLatitude: CLLocationDegrees = 46.9167
        let bernLongitude: CLLocationDegrees = 7.4667
        
        let bernCoordinates = CLLocationCoordinate2DMake(bernLatitude, bernLongitude)
        let deltaSpan = MKCoordinateSpanMake(15.00, 15.00)
        
        self.studentsLocationMapView.region = MKCoordinateRegion(center: bernCoordinates, span: deltaSpan)
        
        
        self.point.coordinate = CLLocationCoordinate2DMake(46.00, 7.46)
        self.studentsLocationMapView.addAnnotation(point)
        
    }



}

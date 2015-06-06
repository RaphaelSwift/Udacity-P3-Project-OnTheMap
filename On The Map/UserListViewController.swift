//
//  UserListViewController.swift
//  On The Map
//
//  Created by Raphael Neuenschwander on 04.06.15.
//  Copyright (c) 2015 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    var studentsInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    //MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        PARSEClient.SharedInstance().getStudentsInformation() { studentsInformation, error in
            if let studentsInformation = studentsInformation {
                self.studentsInformation = studentsInformation
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //Reload the tableview
                    self.studentsTableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInformation.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let student = studentsInformation[indexPath.row]
        
        let cell = studentsTableView.dequeueReusableCellWithIdentifier("StudentListTableViewCell") as! UITableViewCell

        
        /* Set cell tdefaults */
        cell.textLabel?.text = " \(student.firstName!) \(student.lastName!)"
        cell.imageView?.image = UIImage(named: "Pin")
        
        return cell
        
    }

}

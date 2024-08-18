//
//  AddTripPageViewController.swift
//  TripApplication
//
//  Created by student on 18/8/2024.
//

import UIKit
import CoreData

class AddTripPageViewController: UIViewController {

    @IBOutlet weak var iwanttodoTextView: UITextView!
    @IBOutlet weak var enddate: UITextField!
    @IBOutlet weak var startdate: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var startlocation: UITextField!
    @IBOutlet weak var tripname: UITextField!

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePickers()
    }
    
    private func setupDatePickers() {
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        startdate.inputView = startDatePicker
        
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        enddate.inputView = endDatePicker
    }
    
    @objc private func startDateChanged(datePicker: UIDatePicker) {
        startdate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func endDateChanged(datePicker: UIDatePicker) {
        enddate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // Check if all text fields are not nil
        if let destinationText = destination.text,
           let endDateText = enddate.text,
           let startDateText = startdate.text,
           let tripNameText = tripname.text {
            // Call save function with unwrapped values
            save(idestination: destinationText, ienddate: endDateText, istartdate: startDateText, itripname: tripNameText)
        } else {
            // Handle the case where any of the text fields is nil
            print("Please fill in all fields")
        }
    }
    
    @IBAction func enddatepickerTapped(_ sender: Any) {
        enddate.becomeFirstResponder()
    }
    
    @IBAction func startdatepickerTapped(_ sender: Any) {
        startdate.becomeFirstResponder()
    }
    
    @IBAction func resetAllTapped(_ sender: Any) {
        startdate.text = ""
        enddate.text = ""
        destination.text = ""
        startlocation.text = ""
        tripname.text = ""
        iwanttodoTextView.text = ""
    }
    
    func save(idestination:String,ienddate:String,istartdate:String,itripname:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "TripEntity", into: managedContext)
        
        contact.setValue(idestination, forKeyPath: "destination")
        contact.setValue(ienddate, forKeyPath: "enddate")
        contact.setValue(istartdate, forKeyPath: "startdate")
        contact.setValue(itripname, forKeyPath: "tripname")
      
        do {
            try managedContext.save()
         
            let alertController = UIAlertController(title: "Success", message: "The data inserted coredata successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
         
            startdate.text = ""
            enddate.text = ""
            destination.text = ""
            startlocation.text = ""
            tripname.text = ""
            iwanttodoTextView.text = ""
            present(alertController, animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}


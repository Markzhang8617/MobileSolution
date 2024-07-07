//
//  TaskCreationViewController.swift
//  TaskApplication
//
//  Created by mac on 6/7/2024.
//

import UIKit

class TaskCreationViewController: UIViewController{

    @IBOutlet weak var descriptionlabel: UITextView!
    @IBOutlet weak var duedatelabel: UITextField!
    @IBOutlet weak var titlelabel: UITextField!
    @IBOutlet weak var myimageview: UIImageView!

    // Create a date picker
    let datePicker = UIDatePicker()
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set date picker mode to date and time
        datePicker.datePickerMode = .dateAndTime
        // Set locale to ensure consistent date format (e.g., English US)
        datePicker.locale = Locale(identifier: "en_US")
        // Connect date picker's value changed event to a function
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        // Set date picker as the input view for duedatelabel
        duedatelabel.inputView = datePicker

        // Add a toolbar with a done button to dismiss the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        duedatelabel.inputAccessoryView = toolbar
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture1)
        

    }

    // Function called when date picker value changes
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Update duedatelabel text with selected date
        duedatelabel.text = dateFormatter.string(from: sender.date)
    }

    // Function called when the done button on the toolbar is tapped
    @objc func doneButtonTapped() {
        // Dismiss the date picker by resigning first responder
        duedatelabel.resignFirstResponder()
    }

    @IBAction func addphotoTapped(_ sender: Any) {
        // Implement functionality to add a photo
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
       
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func doneTapped(_ sender: Any) {
        // Check if required fields are not empty
        if titlelabel.text != ""  && duedatelabel.text != "" {
            fileName =  UUID().uuidString
            
            //save image to document file
            saveImageToDatabase()
            
            // Save data to UserDefaults
            saveDataToUserDefaults()
            
            // Show success alert
            showSuccessAlert()
            
            //update main table list
            NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
            
            // Clear the UI fields
            titlelabel.text = ""
            descriptionlabel.text = ""
            duedatelabel.text = ""
            myimageview.image = UIImage(systemName: "photo.artframe")
        } else {
            showAlert()
        }
    }

    func saveDataToUserDefaults() {
        // Get data from UI elements
        let title = titlelabel.text
        let description = descriptionlabel.text
        let duedate = duedatelabel.text
        
        // Check if there is existing data in UserDefaults
        var taskArray = getUserDefaultsTaskArray() ?? []
        
        // Create a dictionary with the data
        let taskData = [
            "title": title ?? "",
            "description": description ?? "",
            "filename": fileName,
            "duedate": duedate ?? "",
            "status":"Pending"
            
        ]
        
        
        // Append the new task data to the array
        taskArray.append(taskData)
        
        // Save the updated array to UserDefaults
        UserDefaults.standard.set(taskArray, forKey: "taskArray")
    }

    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Task added successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
       
       func getUserDefaultsTaskArray() -> [[String: String]]? {
           // Retrieve the task array from UserDefaults
           return UserDefaults.standard.object(forKey: "taskArray") as? [[String: String]]
       }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Alert",
            message: "title or duedate not null!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveImageToDatabase(){
       
        guard let selectedImage = myimageview.image else {
            return
        }

        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        do {
            try imageData.write(to: fileURL)

            
        } catch {
            print("error：\(error.localizedDescription)")
        }
    }
}

extension TaskCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            myimageview.image = selectedImage
        }
        
        if let imageUrl = info[.imageURL] as? URL {
          
        } else if let referenceUrl = info[.referenceURL] as? URL {

        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
       
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "selectedSegmentIndex")
    }
    
    
}

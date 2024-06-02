//
//  ViewController.swift
//  Lab4
//
//  Created by user246846 on 6/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var surName: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func resetButton(_ sender: Any) {
        firstName.text = ""
        surName.text = ""
        address.text = ""
        city.text = ""
        dateOfBirth.text = ""
        textView.text = ""
    }
    
    
    @IBAction func declineButton(_ sender: Any) {
        firstName.text = ""
        surName.text = ""
        address.text = ""
        city.text = ""
        dateOfBirth.text = ""
        textView.text = "You have declined!"
    }
    
    
    @IBAction func acceptButton(_ sender: Any) {
        var firstNameText: String? = firstName.text
        var surNameText: String? = surName.text
        var addressText: String? = address.text
        var cityText: String? = city.text
        var dateOfBirthText: String? = dateOfBirth.text
        
        let firstNameValue = firstNameText ?? ""
        let surNameValue = surNameText ?? ""
        let addressValue = addressText ?? ""
        let cityValue = cityText ?? ""
        let dateOfBirthValue = dateOfBirthText ?? ""
        
        
        if(firstNameValue.isEmpty || surNameValue.isEmpty || addressValue.isEmpty ||  cityValue.isEmpty || dateOfBirthValue.isEmpty){
            textView.text="Please input the First Name, Surname, Address, City and Date of Birth"
        } else {
            guard let ageValue = dateOfBirth.text,!ageValue.isEmpty else{
                return
            }
            if let birthdate = parseDate(from: ageValue){
                let age = calculateAge(from: birthdate)
                if(age > 18){
                    let resultText = "I, {\(firstNameText!), \(surNameText!)}, currently living at {\(addressText!)} in the city of {\(cityText!)} do hereby accept the terms and conditions assignment.\n I am {\(age))} and therefore am able to accept the conditions of this assignment."
                    textView.text = resultText
                } else {
                    textView.text="Age is below 18, action not allowed"
                }
            } else{
                textView.text="Date of Birth format error"
            }
        }
    }
    
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    func calculateAge(from birthDate: Date) -> Int {
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
            return ageComponents.year!
    }
}


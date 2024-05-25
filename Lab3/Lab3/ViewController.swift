//
//  ViewController.swift
//  Lab3
//
//  Created by user246846 on 5/24/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var country: UITextField!
        
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var resultView: UITextView!
        
    @IBOutlet weak var prompt: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
               
        var firstNameText: String? = firstName.text
        var lastNameText: String? = lastName.text
        var countryText: String? = country.text
        var ageText: String? = age.text
                
        let resultText = "Full Name: \(firstNameText!) \(lastNameText!) \n Country: \(countryText!) \n Age: \(ageText!)"
        resultView.text = resultText
        prompt.isHidden = true
    }
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        var firstNameText: String? = firstName.text
        var lastNameText: String? = lastName.text
        var countryText: String? = country.text
        var ageText: String? = age.text
        
        let firstNameValue = firstNameText ?? ""
        let lastNameValue = lastNameText ?? ""
        let countryValue = countryText ?? ""
        let ageValue = ageText ?? ""
        
        if firstNameValue.isEmpty || lastNameValue.isEmpty || countryValue.isEmpty || ageValue.isEmpty {
            prompt.text = "Complete the missing Info!"
        } else {
            prompt.text = "Successfully submitted!"
        }
        
        prompt.isHidden = false
        resultView.text = ""

    }
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        firstName.text = ""
        lastName.text = ""
        country.text = ""
        age.text = ""
        resultView.text = ""
        prompt.isHidden = true
    }
    
}


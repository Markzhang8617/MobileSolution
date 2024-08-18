//
//  TripExpenseViewController.swift
//  TripApplication
//
//  Created by student on 18/8/2024.
//

import UIKit

class TripExpenseViewController: UIViewController {

    @IBOutlet weak var expenseAmountInput: UITextField!
    @IBOutlet weak var expenseNameInput: UITextField!
    @IBOutlet weak var tripnameLabel: UILabel!
    @IBOutlet weak var theTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    @IBAction func resetTapped(_ sender: Any) {
    }
    

}

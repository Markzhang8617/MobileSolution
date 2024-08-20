//
//  TripExpenseViewController.swift
//  TripApplication
//
//  Created by student on 18/8/2024.
//

import UIKit
import CoreData

class TripExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var myamount: UILabel!

    @IBOutlet weak var expenseAmountInput: UITextField!
    @IBOutlet weak var expenseNameInput: UITextField!
    @IBOutlet weak var tripnameLabel: UILabel!
    @IBOutlet weak var theTable: UITableView!
    static var mytripname: String = ""
       var expenses: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tripnameLabel.text = TripExpenseViewController.mytripname
        self.theTable.dataSource = self
              self.theTable.delegate = self
              fetchExpenses()
      
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let expenseAmount = expenseAmountInput.text, !expenseAmount.isEmpty,
              let expenseName = expenseNameInput.text, !expenseName.isEmpty,
              let tripName = tripnameLabel.text, !tripName.isEmpty else {
           
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
    
        save(tripanameLabel: tripName, expensename: expenseName, expenseamount: expenseAmount)
    }

    
    @IBAction func resetTapped(_ sender: Any) {
        expenseNameInput.text = ""
        expenseAmountInput.text = ""
    }

    func save(tripanameLabel: String, expensename: String, expenseamount: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let expense = NSEntityDescription.insertNewObject(forEntityName: "ExpenseEntity", into: managedContext)
        
        expense.setValue(expenseamount, forKeyPath: "expenseamount")
        expense.setValue(expensename, forKeyPath: "expensename")
        expense.setValue(tripanameLabel, forKeyPath: "tripname")
        
        do {
            try managedContext.save()
            let alertController = UIAlertController(title: "Success", message: "The data inserted coredata successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            expenseNameInput.text = ""
            expenseAmountInput.text = ""
            fetchExpenses()  // Fetch and reload data after saving
            present(alertController, animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    

}

extension TripExpenseViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripExpenseTableViewCell", for: indexPath) as! TripExpenseTableViewCell
        
        let expense = expenses[indexPath.row]
        let expenseName = expense.value(forKeyPath: "expensename") as? String ?? "Unknown"
        let expenseAmount = expense.value(forKeyPath: "expenseamount") as? String ?? "0"
        
        cell.expenseNameLabel?.text = "\(expenseName): \(expenseAmount)"
        
        return cell
    }
}


extension TripExpenseViewController {
    func fetchExpenses() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
           }
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExpenseEntity")
        fetchRequest.predicate = NSPredicate(format: "tripname == %@", tripnameLabel.text ?? "")
           
           do {
               expenses = try managedContext.fetch(fetchRequest)
               var totalAmount: Double = 0.0
               
               // 计算总金额
               for expense in expenses {
                   if let amountString = expense.value(forKeyPath: "expenseamount") as? String,
                      let amount = Double(amountString) {
                       totalAmount += amount
                   }
               }
               
               // 更新 UI
               DispatchQueue.main.async {
                   self.theTable.reloadData()
                   self.myamount.text = "Trip Expense: total " + String(format: "%.2f", totalAmount)
               }
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
           }
       }
}

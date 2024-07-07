//
//  ViewController.swift
//  TaskApplication
//
//  Created by mac on 6/7/2024.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var duedatesortingview: UIView!
    @IBOutlet weak var theTable: UITableView!
    
    var taskArray: [[String: String]] = []
    var originalArray:[[String: String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from UserDefaults
        loadDataFromUserDefaults()
        filterTasksByStatus(selectedStatus)
        sortTasksByDueDate(selectedDueDate)
        
        // Update table
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name("UpdateTable"), object: nil)

       
    }
    

    //status and duedate sorting 
    @IBOutlet weak var statussegment: UISegmentedControl!
    @IBOutlet weak var duedatesegment: UISegmentedControl!
   
    @IBAction func statusselectedTapped(_ sender: UISegmentedControl) {
        
        NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
        
           let selectedIndex = sender.selectedSegmentIndex
           let selectedTitle = sender.titleForSegment(at: selectedIndex) ?? "Unknown"
         
           // Filter tasks based on selected status
           filterTasksByStatus(selectedTitle)
        
        
       }
    var selectedStatus = "Pending"
    var selectedDueDate = "Ascending"
    func filterTasksByStatus(_ status: String) {
        taskArray = originalArray
       
           if status == "Pending" {
           
               // Filter tasks where status is "Pending"
              selectedStatus = "Pending"
               taskArray = taskArray.filter { $0["status"] == "Pending" }
           } else {
              
               // Filter tasks where status is "Completed"
               selectedStatus = "Completed"
               taskArray = taskArray.filter { $0["status"] == "Completed" }
           }
        
    
       
        DispatchQueue.main.async {
            self.theTable.reloadData()
        }
        
           
       }
    
       @IBAction func duedateselectedTapped(_ sender: UISegmentedControl) {
           let selectedIndex = sender.selectedSegmentIndex
           let selectedTitle = sender.titleForSegment(at: selectedIndex) ?? "Unknown"
      
           
           // Sort tasks based on selected due date order
           sortTasksByDueDate(selectedTitle)
       }
 
       
       func sortTasksByDueDate(_ order: String) {
           if order == "Ascending" {
               // Sort tasks by due date in ascending order
               selectedDueDate = "Ascending"
               taskArray.sort { $0["duedate"]! < $1["duedate"]! }
           } else {
               // Sort tasks by due date in descending order
               selectedDueDate = "Descending"
               taskArray.sort { $0["duedate"]! > $1["duedate"]! }
           }
           DispatchQueue.main.async {
               self.theTable.reloadData()
           }
       }
    
    @objc func updateTable() {
        taskArray.removeAll()
        originalArray.removeAll()
        loadDataFromUserDefaults()
      
        filterTasksByStatus(selectedStatus)
        sortTasksByDueDate(selectedDueDate)
        DispatchQueue.main.async {
            self.theTable.reloadData()
        }
    }
    
    func loadDataFromUserDefaults() {
        if let retrievedTaskArray = getUserDefaultsTaskArray() {
            originalArray = retrievedTaskArray
            taskArray = retrievedTaskArray
            print(taskArray)
        }
    }
    
    func getUserDefaultsTaskArray() -> [[String: String]]? {
        // Retrieve the task array from UserDefaults
        return UserDefaults.standard.object(forKey: "taskArray") as? [[String: String]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section, which is equal to the number of tasks in taskArray
        return taskArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure each cell in the table view
        
        // Dequeue a reusable cell with identifier "TaskListTableViewCell" for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        
        // Retrieve the task data for the current row (indexPath.row)
        let task = taskArray[indexPath.row]
        
        // Assign task details to UI elements in the cell
        cell.tasktitle.text = task["title"]
        cell.taskdescription.text = task["description"]
        cell.taskduedate.text = task["duedate"]
        cell.selectionStyle = .none  // Disable cell selection
        
        // Configure the SegmentedControl for status selection
        cell.statusSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        cell.statusSegment.tag = indexPath.row  // Set tag to identify which row's segment control is changed
        
        // Set initial selected segment based on task status
        if task["status"] == "Pending" {
            cell.statusSegment.selectedSegmentIndex = 0
        } else {
            cell.statusSegment.selectedSegmentIndex = 1
        }
        
        // Load and display task image based on filename
        var imageString = task["filename"]
        if imageString!.contains("-") {
      
            cell.taskimage.image = loadImageFromPath(filename: imageString!)
            cell.taskimage.layer.cornerRadius = 10
            cell.taskimage.clipsToBounds = true
            cell.taskimage.contentMode = .scaleAspectFill
        } else {
            // If filename does not contain '-', assume it's a resource name and load as UIImage
            cell.taskimage.image = UIImage(named: imageString!)
        }
      
        
        return cell  // Return configured cell
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        // Get the task associated with the changed segment
        let index = sender.tag
        print("haha \(index)")
        var task = taskArray[index]
        
        // Update the task status
        if sender.selectedSegmentIndex == 0 {
            task["status"] = "Pending"
        } else {
            task["status"] = "Completed"
        }
        taskArray[index] = task
        print("haha what is \( taskArray[index])")
        // Save the updated task array to UserDefaults
        saveTaskArrayToUserDefaults()
        
        // Refresh the table
        theTable.reloadData()
        
    }
    
    func saveTaskArrayToUserDefaults() {
        //user default settings name
        UserDefaults.standard.set(taskArray, forKey: "taskArray")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after selection (optional)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Perform the segue with identifier "showDetails"
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = sender as? IndexPath {
                let task = taskArray[indexPath.row]
                
                // Retrieve the destination view controller
                let destinationVC = segue.destination as! DetailedTaskViewController
                
                // Pass the necessary data to the destination view controller
                destinationVC.titles = task["title"]
                destinationVC.status = task["status"]
                destinationVC.descriptions = task["description"]
                destinationVC.imagestring = task["filename"]
                destinationVC.duedatestring = task["duedate"]

                
            }
        }
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete swipe right action
          if editingStyle == .delete {
             
              taskArray.remove(at: indexPath.row)
              
             
              saveTaskArrayToUserDefaults()
              
     
              tableView.deleteRows(at: [indexPath], with: .fade)
          }
      }
    

    func loadImageFromPath(filename: String) -> UIImage {
        //load document storage image
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return UIImage(systemName: "photo.artframe")!
        }
        
        let filePath = documentsURL.appendingPathComponent(filename).path
        
        if fileManager.fileExists(atPath: filePath) {
            if let image = UIImage(contentsOfFile: filePath) {
                return image
            }
        } else {
            if let defaultImage = UIImage(named: filename) {
                return defaultImage
            }
        }
        
        return UIImage(systemName: "photo.artframe")!
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        //clear all setting
        
        taskArray.removeAll()
        originalArray.removeAll()
        loadDataFromUserDefaults()
        filterTasksByStatus("Pending")
        sortTasksByDueDate("Ascending")
       statussegment.selectedSegmentIndex = 0
       duedatesegment.selectedSegmentIndex = 0
        DispatchQueue.main.async {
            self.theTable.reloadData()
        }
       
    }
    
 
    
}

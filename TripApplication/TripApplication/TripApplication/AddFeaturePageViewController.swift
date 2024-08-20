//
//  AddFeaturePageViewController.swift
//  TripApplication
//
//  Created by student on 18/8/2024.
//

import UIKit
import CoreData

class AddFeaturePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var theTable: UITableView!
    @IBOutlet weak var mysearchbox: UISearchBar!

    // The list of all contacts
    static var contacts: [NSManagedObject] = []
    // The list of filtered contacts
    var filteredContacts: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mysearchbox.delegate = self
        fetchData()
        filteredContacts = AddFeaturePageViewController.contacts
        theTable.reloadData()

        // Enable swipe to delete
        theTable.isEditing = false
    }

    func fetchData() {
        AddFeaturePageViewController.contacts.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TripEntity")
        do {
            AddFeaturePageViewController.contacts = try managedContext.fetch(fetchRequest)
            filteredContacts = AddFeaturePageViewController.contacts
            for contact in AddFeaturePageViewController.contacts {
                if let name = contact.value(forKey: "tripname") as? String {
                    print("Name: \(name)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFeaturePageTableViewCell", for: indexPath) as! AddFeaturePageTableViewCell
        let contact = filteredContacts[indexPath.row]
        cell.tripnameLabel?.text = contact.value(forKeyPath: "tripname") as? String
        cell.destinationLabel.text = contact.value(forKeyPath: "destination") as? String
        return cell
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all contacts
            filteredContacts = AddFeaturePageViewController.contacts
        } else {
            // Filter contacts based on search text
            filteredContacts = AddFeaturePageViewController.contacts.filter { contact in
                let tripName = contact.value(forKey: "tripname") as? String ?? ""
                let destination = contact.value(forKey: "destination") as? String ?? ""
                return tripName.lowercased().contains(searchText.lowercased()) ||
                       destination.lowercased().contains(searchText.lowercased())
            }
        }
        theTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetails" {
                if let destinationVC = segue.destination as? TripDetailsViewController,
                   let selectedContact = sender as? NSManagedObject {
                    destinationVC.tripname = selectedContact.value(forKey: "tripname") as? String
                    destinationVC.destination = selectedContact.value(forKey: "destination") as? String
                }
            }
        }

    
    // MARK: - UITableViewDelegate

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Get the selected contact
           let selectedContact = filteredContacts[indexPath.row]
           // Perform the segue and pass data
           performSegue(withIdentifier: "showDetails", sender: selectedContact)
       }

    // MARK: - Delete functionality (Swipe to Delete)

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the contact from Core Data
            let contactToDelete = filteredContacts[indexPath.row]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(contactToDelete)

            do {
                try managedContext.save()
                // Update the arrays and reload the table view
                filteredContacts.remove(at: indexPath.row)
                AddFeaturePageViewController.contacts = try managedContext.fetch(NSFetchRequest(entityName: "TripEntity"))
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
}

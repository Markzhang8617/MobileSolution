//
//  ViewController.swift
//  FormTable
//
//  Created by user246846 on 6/10/24.
//

import UIKit

extension UserDefaults {
    private static let itemsKey = "items"
    
    static func saveItems(_ items: [String]) {
        UserDefaults.standard.set(items, forKey: itemsKey)
    }
    
    static func loadItems() -> [String] {
        return UserDefaults.standard.stringArray(forKey: itemsKey) ?? []
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
        
    @IBOutlet weak var mTable: UITableView!
    
    var items = [String]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell",for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
    }

    @IBAction func addToDo(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Write an Item"
        }
        let addAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let newItem = alertController.textFields?.first?.text, !newItem.isEmpty {
                self?.items.append(newItem)
                self?.mTable.reloadData()
                self?.saveItems()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTable.dataSource = self
        mTable.delegate = self
        loadItems()
    }
    
    private func saveItems() {
        UserDefaults.saveItems(items)
    }
    
    private func loadItems() {
        items = UserDefaults.loadItems()
    }

}


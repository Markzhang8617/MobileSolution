//
//  HomeViewController.swift
//  Assignment2
//
//  Created by user246846 on 6/23/24.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBAction func monitorButton(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "", message: "No Monitors yet.Check back later!", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

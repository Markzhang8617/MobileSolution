//
//  DetailedTaskViewController.swift
//  TaskApplication
//
//  Created by mac on 7/7/2024.
//

import UIKit

class DetailedTaskViewController: UIViewController {

    var status:String?
    var descriptions:String?
    var titles:String?
    var imagestring:String?
    var duedatestring:String?
    
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var duedatelabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var myimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.statuslabel.text = status!
        self.descriptionlabel.text = descriptions!
        self.titlelabel.text = titles!
       // self.myimage.image =
        self.duedatelabel.text = duedatestring!
        
        if imagestring!.contains("-") {
            print("Handling case where filename contains '-'")
            self.myimage.image = loadImageFromPath(filename: imagestring!)
            self.myimage.layer.cornerRadius = 10
            self.myimage.clipsToBounds = true
            self.myimage.contentMode = .scaleAspectFill
        } else {
            // If filename does not contain '-', assume it's a resource name and load as UIImage
            self.myimage.image = UIImage(named: imagestring!)
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
   
}

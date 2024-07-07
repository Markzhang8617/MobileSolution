//
//  TaskListTableViewCell.swift
//  TaskApplication
//
//  Created by mac on 6/7/2024.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var taskduedate: UILabel!
    @IBOutlet weak var taskdescription: UILabel!
    @IBOutlet weak var tasktitle: UILabel!
    @IBOutlet weak var taskimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

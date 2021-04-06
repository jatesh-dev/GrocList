//
//  GrocNameCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 25/02/2021.
//
import UIKit
class GrocNameCell: UITableViewCell {
    
    @IBOutlet weak var assignedDateLabel: UILabel!
    @IBOutlet weak var assignedTimeLabel: UILabel!
    @IBOutlet weak var labelGroc: UILabel!
    @IBOutlet weak var assigneeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(grocData: Grocs) {
        let grocName = NSMutableAttributedString(string: grocData.grocName ?? "")
        labelGroc.attributedText = grocName
        let dateTime = CommonFunctions.shared.setTimeDateFormat(data: grocData.timestamp ?? "")
        assignedTimeLabel.text = dateTime["time"]
        assignedDateLabel.text = dateTime["date"]
    }
}

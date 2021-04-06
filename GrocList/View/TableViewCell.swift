//
//  TableViewCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 25/02/2021.
//

import UIKit

class GrocNameCell: UITableViewCell {

    @IBOutlet weak var labelTodo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

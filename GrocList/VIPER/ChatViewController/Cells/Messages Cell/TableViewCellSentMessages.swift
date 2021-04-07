//
//  TableViewCellSentMessages.swift
//  GrocList
//
//  Created by Syed Asad on 01/03/2021.
//

import UIKit

class TableViewCellSentMessages: UITableViewCell {
	
	@IBOutlet weak var viewSentMessages: UIView!
	@IBOutlet weak var labelSentMessages: UILabel!
	@IBOutlet weak var labelTimeSent: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
}

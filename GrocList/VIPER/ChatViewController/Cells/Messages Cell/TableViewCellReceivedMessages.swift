//
//  TableViewCellReceivedMessages.swift
//  GrocList
//
//  Created by Syed Asad on 01/03/2021.
//

import UIKit

class TableViewCellReceivedMessages: UITableViewCell {
	
	@IBOutlet weak var labelReceivedMessages: UILabel!
	@IBOutlet weak var viewReceivedMessages: UIView!
	@IBOutlet weak var labelTimeReceive: UILabel!
	@IBOutlet weak var viewProfileImage: UIView!
	@IBOutlet weak var imageProfile: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
		imageProfile.layer.borderColor = UIColor.gray.cgColor
		imageProfile.layer.borderWidth = 0.5
    }
}

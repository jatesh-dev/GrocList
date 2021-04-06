//
//  ContactTableViewCell.swift
//  GrocList
//
//  Created by Syed Asad on 02/03/2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
	
	@IBOutlet weak var viewUserImage: UIView!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelDetail: UILabel!
    
	override func awakeFromNib() {
        super.awakeFromNib()
		imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
		imageProfile.layer.borderColor = UIColor.gray.cgColor
		imageProfile.layer.borderWidth = 0.5
    }
}

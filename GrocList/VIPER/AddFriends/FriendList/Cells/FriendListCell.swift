//
//  MainUserCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 02/03/2021.
//
import UIKit

class FriendListCell: UITableViewCell {
    @IBOutlet weak var viewProfilePicture: UIView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewProfilePicture.layer.cornerRadius = imageViewProfilePicture.frame.height/2
        imageViewProfilePicture.layer.borderWidth = 0.1
        imageViewProfilePicture.image = nil
    }
    
    func configure (user: User) {
        labelName.text = user.name
    }
}

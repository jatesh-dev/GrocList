//
//  MainUserCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 02/03/2021.
//
import UIKit
class MainUserCell: UITableViewCell {
    @IBOutlet weak var viewProfilePicture: UIView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelGrocStatus: UILabel!
    @IBOutlet weak var buttonUnreadCount: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewProfilePicture.layer.cornerRadius = imageViewProfilePicture.frame.height/2
        imageViewProfilePicture.layer.borderWidth = 0.1
        buttonUnreadCount.layer.cornerRadius = buttonUnreadCount.frame.width/2
        buttonUnreadCount.isHidden = true
    }
}

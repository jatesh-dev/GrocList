//
//  MainUserCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 02/03/2021.
//
import UIKit

protocol AddFriendCellDelegate: class {
    func didAddFriend(userID: String)
}

class AddFriendCell: UITableViewCell {
    @IBOutlet weak var viewProfilePicture: UIView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var userID: String = ""
    weak var delegate: AddFriendCellDelegate?
    
    @IBAction func addFriend(_ sender: UIButton) {
        delegate?.didAddFriend(userID: userID)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewProfilePicture.layer.cornerRadius = imageViewProfilePicture.frame.height/2
        imageViewProfilePicture.layer.borderWidth = 0.1
    }
    
    func configure (user: User) {
        self.userID = user.userID!
        labelName.text = user.name
    }
}

//
//  MainUserCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 02/03/2021.
//
import UIKit

protocol RequestCellDelegate: class {
    func friendRequest(accept: Bool, userID: String)
}

class RequestCell: UITableViewCell {
    @IBOutlet weak var viewProfilePicture: UIView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    var currentUserID: String = ""
    weak var delegate: RequestCellDelegate?
    
    @IBAction func acceptRequest(_ sender: UIButton) {
        delegate?.friendRequest(accept: true, userID: self.currentUserID)
    }
    
    @IBAction func declineRequest(_ sender: UIButton) {
        delegate?.friendRequest(accept: false, userID: self.currentUserID)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewProfilePicture.layer.cornerRadius = imageViewProfilePicture.frame.height/2
        imageViewProfilePicture.layer.borderWidth = 0.1
    }
    
    func configure(user: User) {
        self.currentUserID = user.userID ?? ""
        labelName.text = user.name
    }
}

//
//  ProfileTableViewCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 03/03/2021.
//
import UIKit
class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileCellImageView: UIImageView!
    @IBOutlet weak var profileEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileCellImageView.layer.cornerRadius = profileCellImageView.frame.width/2
        profileCellImageView.layer.borderWidth = 0
    }
}

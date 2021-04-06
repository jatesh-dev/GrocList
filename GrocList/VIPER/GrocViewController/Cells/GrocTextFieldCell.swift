//
//  GrocTextFieldCell.swift
//  GrocList
//
//  Created by Jatesh Kumar on 25/02/2021.
//

import UIKit

protocol DataAdditionDelegate: class {
    func didTap(data: String)
}
class GrocTextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textFieldGroc: UITextField!
    @IBOutlet weak var buttonAddGroc: UIButton!
    weak var delegate: DataAdditionDelegate?
    @IBAction func buttonAddGrocClick(_ sender: UIButton) {
        guard let grocText = textFieldGroc.text else { return }
        delegate?.didTap(data: grocText)
        textFieldGroc.text = ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldAttributes()
    }
    private func textFieldAttributes () {
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        border.frame = CGRect(origin: CGPoint(x: 16, y: self.frame.size.height - 10), size: CGSize(width: textFieldGroc.frame.width - 25, height: 0.5))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

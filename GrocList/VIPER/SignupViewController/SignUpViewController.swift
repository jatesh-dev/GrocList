//
//  ViewController.swift
//  GrocList
//
//  Created by Shahzaib Iqbal Bhatti on 2/22/21.
//

import UIKit
import Photos

class SignUpViewController: UIViewController, UINavigationControllerDelegate {
	
	@IBOutlet weak var fieldName: UITextField!
	@IBOutlet weak var fieldPhoneNumber: UITextField!
	@IBOutlet weak var fieldEmailAddress: UITextField!
	@IBOutlet weak var fieldPassword: UITextField!
	@IBOutlet weak var fieldConfirmPassword: UITextField!
	@IBOutlet weak var buttonOutletSignUp: UIButton!
    @IBOutlet weak var buttonSelectImage: UIButton!
    @IBOutlet weak var viewImagePicker: UIView!
    
	var imagePickerController = UIImagePickerController()
    var imageUrl: URL?
    var userID: String = ""
    
    var presenter: SignupViewToPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        setCornerRadius(field: fieldName)
        setCornerRadius(field: fieldPhoneNumber)
        setCornerRadius(field: fieldEmailAddress)
        setCornerRadius(field: fieldPassword)
        setCornerRadius(field: fieldConfirmPassword)
        
        buttonOutletSignUp.layer.cornerRadius = 10.0
        buttonOutletSignUp.layer.borderWidth = 0.1
        buttonSelectImage.layer.cornerRadius = buttonSelectImage.frame.width/2
        buttonSelectImage.layer.borderWidth = 0.3
        buttonSelectImage.contentMode = UIView.ContentMode.scaleAspectFit
        buttonSelectImage.layer.masksToBounds = true
        
        self.attributedPlaceholder(fieldView: fieldName, text: "Full Name")
        self.attributedPlaceholder(fieldView: fieldPhoneNumber, text: "Phone Number")
        self.attributedPlaceholder(fieldView: fieldEmailAddress, text: "Email Address")
        self.attributedPlaceholder(fieldView: fieldEmailAddress, text: "Email Address")
        self.attributedPlaceholder(fieldView: fieldPassword, text: "Enter 6 digits long Password")
        self.attributedPlaceholder(fieldView: fieldConfirmPassword, text: "Confirm Password")
    }
    
    @IBAction func buttonActionSelectImage(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func buttonActionSignIn(_ sender: Any) {
        switchToSignInViewController()
    }
    
    @IBAction func buttonActionSignUp(_ sender: Any) {
        let email = fieldEmailAddress.text!
        let password = fieldConfirmPassword.text!
        let name = fieldName.text!
        if name != "", email != "", password != "" {
            if password == fieldPassword.text {
                guard let imageURL = imageUrl else { return }
                presenter?.signupUser(email: email, password: password, name: name, imageUrl: imageURL)
            } else {
                callAlert("Password Incorrect!", "Please provide correct password", action: UIAlertAction(title: "Ok", style: .default, handler: nil))
            }
        } else {
            callAlert("Empty Fields!", "Please fill all the fields", action: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
    }
}

extension SignUpViewController: SignupPresenterToView {
    func checkUserCreated(status: Bool) {
        if status {
            let title = "Registration Successful"
            let description = "Please login to get started!"
            self.callAlert(title, description, action: UIAlertAction(title: "Ok", style: .default, handler: { (_: UIAlertAction) in
                self.switchToSignInViewController()
            }))
        } else {
            let title = "Registration Failed"
            let description = "Some internal error occured, please try again!"
            self.callAlert(title, description, action: UIAlertAction(title: "Ok", style: .default, handler: { (_: UIAlertAction) in
                
            }))
        }
    }
}

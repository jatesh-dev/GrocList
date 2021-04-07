//
//  SignUpViewControllerExtension.swift
//  GrocList
//
//  Created by Jatesh Kumar on 16/03/2021.
//

import UIKit
import Photos

extension SignUpViewController: UIImagePickerControllerDelegate {}

extension SignUpViewController {
    func checkPermissions () {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({(_: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler (status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Authorized")
        } else {
            print("Not authorized")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imageUrl = url
            self.buttonSelectImage.kf.setImage(with: url, for: .normal)
            print(url.deletingPathExtension().lastPathComponent)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func setCornerRadius(field: UITextField) {
        field.layer.cornerRadius = 10.0
        field.layer.borderWidth = 0.3
    }
    
    func switchToSignInViewController() {
        let signinViewController = LoginRouter.createModule()
        self.navigationController?.pushViewController(signinViewController, animated: true)
    }
    
    func attributedPlaceholder(fieldView: UITextField, text: String) {
        fieldView.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor .lightGray])
    }
    
    func callAlert(_ title: String, _ description: String, action: UIAlertAction) {
        let alert  = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

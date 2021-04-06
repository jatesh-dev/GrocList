//
//  LogInViewController.swift
//  GrocList
//
//  Created by Syed Asad on 23/02/2021.
//

import UIKit
import Firebase
class LogInViewController: UIViewController {
    
	@IBOutlet weak var fieldEmail: UITextField!
	@IBOutlet weak var fieldPassword: UITextField!
	@IBOutlet weak var buttonOutletLogIn: UIButton!
	
    var presenter: LoginViewToPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setCornerRadius(field: fieldEmail)
		setCornerRadius(field: fieldPassword)
		buttonOutletLogIn.layer.cornerRadius = 10.0
		buttonOutletLogIn.layer.borderWidth = 0.3
		navigationController?.isNavigationBarHidden = true
        
    }
	
    func setCornerRadius(field: UITextField) {
		field.layer.cornerRadius = 10.0
		field.layer.borderWidth = 0.3
	}
	
    @IBAction func buttonActionSignUp(_ sender: Any) {
        let signupViewController = SignupRouter.createModule()
		self.navigationController?.pushViewController(signupViewController, animated: true)
	}
    
	@IBAction func buttonActionLogin(_ sender: Any) {
        guard let email = fieldEmail.text else { return }
        guard let password = fieldPassword.text else { return }
		if email != "" && password != "" {
            presenter?.authenticateUser(email: email, password: password)
		}
	}
}

extension LogInViewController: LoginPresenterToView {
    func updateAuthStatus(status: Bool) {
        if status {
            print("Login Successful")
            
            let mainViewController = MainRouter.createModule()
            let nav = UINavigationController()
            nav.viewControllers = [mainViewController]
            
            navigationController?.pushViewController(mainViewController, animated: true)
        
        } else {
            print("Failed")
        }
    }
}

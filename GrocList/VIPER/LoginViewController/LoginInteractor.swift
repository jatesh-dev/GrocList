//
//  LoginInteractor.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit
import Firebase

class LoginInteractor: LoginPresenterToInteractor {
    var presenter: LoginInteractorToPresenter?
    
    func checkAuth(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] _, error in
            if error != nil {
                print(error as Any)
                self?.presenter?.authStatus(status: false)
                return
            }
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            self?.presenter?.authStatus(status: true)
            
        }
    }
}

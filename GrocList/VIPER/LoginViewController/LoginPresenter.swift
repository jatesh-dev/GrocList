//
//  LoginPresenter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class LoginPresenter: LoginViewToPresenter {
    var view: LoginPresenterToView?
    var interactor: LoginPresenterToInteractor?
    var router: LoginPresenterToRouter?
    
    func authenticateUser(email: String, password: String) {
        interactor?.checkAuth(email: email, password: password)
    }
}

extension LoginPresenter: LoginInteractorToPresenter {
    func authStatus(status: Bool) {
        view?.updateAuthStatus(status: status)
    }
}

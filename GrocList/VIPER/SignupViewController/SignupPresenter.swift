//
//  SignupPresenter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class SignupPresenter: SignupViewToPresenter {
    var view: SignupPresenterToView?
    var interactor: SignupPresenterToInteractor?
    var router: SignupPresenterToRouter?
    
    func signupUser(email: String, password: String, name: String, imageUrl: URL) {
        interactor?.createUser(email: email, password: password, name: name, imageUrl: imageUrl)
    }
}

extension SignupPresenter: SignupInteractorToPresenter {
    func userCreateStatus(status: Bool) {
        view?.checkUserCreated(status: status)
    }
}

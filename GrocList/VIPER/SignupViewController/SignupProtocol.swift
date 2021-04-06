//
//  SignupProtocol.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation

protocol SignupViewToPresenter: class {
    var view: SignupPresenterToView? { get set }
    var interactor: SignupPresenterToInteractor? { get set }
    var router: SignupPresenterToRouter? { get set }
    
    func signupUser(email: String, password: String, name: String, imageUrl: URL)
}

protocol SignupPresenterToInteractor: class {
    var presenter: SignupInteractorToPresenter? { get set }
    func createUser(email: String, password: String, name: String, imageUrl: URL)
}

protocol SignupInteractorToPresenter: class {
    func userCreateStatus(status: Bool)
}

protocol SignupPresenterToView: class {
    func checkUserCreated(status: Bool)
}

protocol SignupPresenterToRouter {
    static func createModule () -> SignUpViewController
}

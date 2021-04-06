//
//  LoginProtocol.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

protocol LoginViewToPresenter: class {
    var view: LoginPresenterToView? { get set }
    var interactor: LoginPresenterToInteractor? { get set }
    var router: LoginPresenterToRouter? { get set }
    func authenticateUser(email: String, password: String)
}

protocol LoginPresenterToInteractor: class {
    var presenter: LoginInteractorToPresenter? { get set }
    func checkAuth(email: String, password: String)
}

protocol LoginInteractorToPresenter: class {
    func authStatus(status: Bool)
}

protocol LoginPresenterToView: class {
    func updateAuthStatus(status: Bool)
}

protocol LoginPresenterToRouter: class {
    static func createModule () -> LogInViewController
}

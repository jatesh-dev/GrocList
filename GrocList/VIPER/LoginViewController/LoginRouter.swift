//
//  LoginRouter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class LoginRouter: LoginPresenterToRouter {
    static func createModule() -> LogInViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController
        
        let presenter: LoginViewToPresenter & LoginInteractorToPresenter = LoginPresenter()
        let interactor: LoginPresenterToInteractor = LoginInteractor()
        let router: LoginPresenterToRouter = LoginRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view!
        
    }
    static var mainstoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}

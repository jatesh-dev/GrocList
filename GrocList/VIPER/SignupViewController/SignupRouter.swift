//
//  SignupRouter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class SignupRouter: SignupPresenterToRouter {
    static func createModule() -> SignUpViewController {
        let view = signupstoryboard.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController
        
        let presenter: SignupViewToPresenter & SignupInteractorToPresenter = SignupPresenter()
        let interactor: SignupPresenterToInteractor = SignupInteractor()
        let router: SignupPresenterToRouter = SignupRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view!
    }
    
    static var signupstoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main)}
}

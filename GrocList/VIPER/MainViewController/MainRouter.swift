//
//  MainRouter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class MainRouter: MainWireframeProtocol {
    static func createModule() -> MainViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
        let presenter: MainPresenterProtocol & MainInteractorOutputProtocol = MainPresenter()
        let interactor: MainInteractorInputProtocol = MainInteractor()
        let router: MainWireframeProtocol = MainRouter()
        
        view?.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view!
        
    }
    static var mainstoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}

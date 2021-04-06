//
//  GrocViewRouter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class GrocViewRouter: GrocViewWireframeProtocol {
    static func createModule(grockKey: String?) -> GrocViewController {
        let view = grocStoryboard.instantiateViewController(identifier: "GrocViewController") as? GrocViewController
        
        let presenter: GrocViewPresenterProtocol & GrocViewInteractorOutputProtocol = GrocViewPresenter()
        let interactor: GrocViewInteractorInputProtocol = GrocViewInteractor()
        let router: GrocViewWireframeProtocol = GrocViewRouter()
        
        view?.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
        view?.grocKey = grockKey
        
        return view!
    }
    static var grocStoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
}

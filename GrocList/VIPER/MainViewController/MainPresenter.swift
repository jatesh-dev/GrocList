//
//  MainPresenter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit
import Firebase

class MainPresenter: MainPresenterProtocol {
    var view: MainViewProtocol?
    var interactor: MainInteractorInputProtocol?
    var router: MainWireframeProtocol?
    
    func showUsers(currentUserID: String) {
        interactor?.getUsers(roomID: currentUserID)
    }
}
extension MainPresenter: MainInteractorOutputProtocol {
    func fetchedFriends(users: [User]) {
        view?.updateView(users: users)
    }
}

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
    
    func showUsers() {
        interactor?.getUsers()
    }
    func friendList(currentUserID: String) {
        interactor?.getFriends(roomID: currentUserID)
    }
}
extension MainPresenter: MainInteractorOutputProtocol {
    func friendsIDs(userID: [String]) {
        view?.checkFriends(userID: userID)
    }
    
    func fetchedUsers(users: [User]) {
        view?.updateView(users: users)
    }
}

//
//  FriendListPresenter.swift
//  GrocList
//
//  Created Jatesh Kumar on 05/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class FriendListPresenter {

    weak private var view: FriendListViewProtocol?
    var interactor: FriendListInteractorInputProtocol?
    private let router: FriendListWireframeProtocol

    init(interface: FriendListViewProtocol, interactor: FriendListInteractorInputProtocol?, router: FriendListWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    deinit {
        print("deinit FriendListPresenter")
    }

    func viewDidLoad() {
        
    }
}

extension FriendListPresenter: FriendListPresenterProtocol {
    func getMyFriendList(myUserID: String) {
        interactor?.getUsers(roomID: myUserID)
    }
}
extension FriendListPresenter: FriendListInteractorOutputProtocol {
    func setFriendListToView(users: [User]) {
        view?.updateView(friends: users)
    }
}

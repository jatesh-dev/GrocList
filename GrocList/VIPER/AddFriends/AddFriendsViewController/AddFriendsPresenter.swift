//
//  AddFriendsPresenter.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class AddFriendsPresenter {

    weak private var view: AddFriendsViewProtocol?
    var interactor: AddFriendsInteractorInputProtocol?
    private let router: AddFriendsWireframeProtocol

    init(interface: AddFriendsViewProtocol, interactor: AddFriendsInteractorInputProtocol?, router: AddFriendsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    deinit {
        print("deinit AddFriendsPresenter")
    }

    func viewDidLoad() {

    }
}

extension AddFriendsPresenter: AddFriendsPresenterProtocol {
    func getAllUsersExceptFriends(roomID: String) {
        interactor?.getAllUsersFromDB(roomID: roomID)
    }
    
    func getFriendList(userID: String) {
        view?.showLoader()
    }
}

extension AddFriendsPresenter: AddFriendsInteractorOutputProtocol {
    func fetchedUsers(users: [User]) {
        view?.setupUsers(users: users)
    }
}

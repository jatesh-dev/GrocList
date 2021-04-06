//
//  FriendRequestsPresenter.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class FriendRequestsPresenter {

    weak internal var view: FriendRequestsViewProtocol?
    var interactor: FriendRequestsInteractorInputProtocol?
    private let router: FriendRequestsWireframeProtocol

    init(interface: FriendRequestsViewProtocol, interactor: FriendRequestsInteractorInputProtocol?, router: FriendRequestsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    deinit {
        print("deinit FriendRequestsPresenter")
    }

    func getAllUsers() {

    }
}

extension FriendRequestsPresenter: FriendRequestsPresenterProtocol {
    func changeFriendRequestStatus(accept: Bool, userID: String, roomKey: String) {
        interactor?.changeFriendRequestStatusIntoDB(accept: accept, userID: userID, roomKey: roomKey)
    }
    
    func getFriendRequests(roomID: String) {
        interactor?.getFriendRequests(roomID: roomID)
    }
    
    func getAllFriendRequests() {
        interactor?.getAllRequestsFromDB()
    }
    
    func viewDidLoad() {
        
    }

}

extension FriendRequestsPresenter: FriendRequestsInteractorOutputProtocol {
    func fetchedFriendRequests(requests: [User]) {
        view?.setupRequests(requests: requests)
    }
}

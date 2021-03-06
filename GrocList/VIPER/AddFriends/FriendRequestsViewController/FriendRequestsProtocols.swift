//
//  FriendRequestsProtocols.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Hasnain Kanji
//

import Foundation

// MARK: Wireframe -
protocol FriendRequestsWireframeProtocol: class {

}
// MARK: Presenter -
protocol FriendRequestsPresenterProtocol: class {
    var view: FriendRequestsViewProtocol? { get set }
    var interactor: FriendRequestsInteractorInputProtocol? { get set }
    
    func getAllFriendRequests(roomID: String)
    func changeFriendRequestStatus(accept: Bool, userID: String, roomKey: String)
}

// MARK: Interactor -
protocol FriendRequestsInteractorOutputProtocol: class {
    func fetchedFriendRequests(requests: [User])
    /* Interactor -> Presenter */
}

protocol FriendRequestsInteractorInputProtocol: class {

    var presenter: FriendRequestsInteractorOutputProtocol? { get set }
    func getAllRequestsFromDB(roomID: String)
    func changeFriendRequestStatusIntoDB(accept: Bool, userID: String, roomKey: String)
    /* Presenter -> Interactor */
}

// MARK: View -
protocol FriendRequestsViewProtocol: class {

    var presenter: FriendRequestsPresenterProtocol? { get set }

    /* Presenter -> ViewController */
    func showLoader()
    func hideLoader()

    func setupRequests(requests: [User])
}

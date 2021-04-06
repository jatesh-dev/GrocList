//
//  FriendListInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 05/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class FriendListInteractor {

    weak var presenter: FriendListInteractorOutputProtocol?
    var allUsers = [User]()
    var friendIDs: [String] = []
    deinit {
        print("deinit FriendListInteractor")
    }
}

extension FriendListInteractor: FriendListInteractorInputProtocol {
    func getFriends(userID: String) {
        self.getUsers()
        GrocDbManager.shared.checkRequests(roomKey: userID) { status in
            switch status {
            case .success(let friends):
                self.friendIDs = []
                for friend in friends where friend.value == "11" {
                    self.friendIDs.append(friend.key)
                }
                self.sortFriends()
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    func getUsers() {
        GrocDbManager.shared.getAllUsers {(users) in
            self.allUsers = [User]()
            switch users {
            case .success(let user):
                self.allUsers.append(contentsOf: user)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    func sortFriends() {
        var friends = [User]()
        for user in allUsers {
            if friendIDs.contains(user.userID!) {
                friends.append(user)
            }
        }
        self.presenter?.setFriendListToView(users: friends)
    }
}

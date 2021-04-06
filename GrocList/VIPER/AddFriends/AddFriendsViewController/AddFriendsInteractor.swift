//
//  AddFriendsInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class AddFriendsInteractor {
    var friends: [String: String] = [:]
    var users = [User]()
    weak var presenter: AddFriendsInteractorOutputProtocol?

    deinit {
        print("deinit AddFriendsInteractor")
    }
}

extension AddFriendsInteractor: AddFriendsInteractorInputProtocol {
    func getAllUsersFromDB() {
        self.users = [User]()
        GrocDbManager.shared.getAllUsers {(users) in
            switch users {
            case .success(let user):
                DispatchQueue.main.async {
                    self.users.append(contentsOf: user)
                    self.sortFriends()
                }
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    func getFriends(roomID: String) {
        self.friends = [:]
        GrocDbManager.shared.checkRequests(roomKey: roomID) { status in
            switch status {
            case .success(let friend):
                self.friends = friend
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    func sortFriends() {
        var arr: [String] = []
        for friend in friends where friend.value == "0" || friend.value == "1" || friend.value == "11" {
            arr.append(friend.key)
        }
        var suggestions = [User]()
        for user in users {
            if arr.contains(user.userID!) {
                print("friend")
            } else {
                suggestions.append(user)
            }
        }
        presenter?.fetchedUsers(users: suggestions)
    }
}

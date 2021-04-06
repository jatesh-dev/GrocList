//
//  MainInteractor.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation

class MainInteractor: MainInteractorInputProtocol {
    var presenter: MainInteractorOutputProtocol?
    var friends: [String: String] = [:]
    func getUsers() {
        GrocDbManager.shared.getAllUsers {(users) in
            switch users {
            case .success(let user):
                self.presenter?.fetchedUsers(users: user)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }

    func getFriends(roomID: String) {
        GrocDbManager.shared.getUsersWithGrocs(roomKey: roomID) { status in
            switch status {
            case .success(let friends):
                self.friends = friends
                var arr: [String] = []
                for friend in friends {
                    arr.append(friend.key)
                }
                self.presenter?.friendsIDs(userID: arr)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

//
//  FriendListInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 05/04/2021.
//  Copyright © 2021 ___NextGenI___. All rights reserved.
//

import UIKit

final class FriendListInteractor {

    weak var presenter: FriendListInteractorOutputProtocol?
    var friends = [User]()
    var friendsIds: [String] = []
    deinit {
        print("deinit FriendListInteractor")
    }
}

extension FriendListInteractor: FriendListInteractorInputProtocol {
    func getUsers(roomID: String) {
        eventDbChildAdded(roomID)
        eventDbChildUpdate(roomID)
        eventDbChildRemoved(roomID)
    }

    func getFriends(userID: String) {
        GrocDbManager.shared.checkRequests(roomKey: userID) { status in
            switch status {
            case .success(let friends):
                self.friendsIds = []
                for friend in friends {
                    self.friendsIds.append(friend.key)
                }
                self.sortFriends()
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    func sortFriends() {
        var allFriends = [User]()
        for user in friends {
            if friendsIds.contains(user.userID!) {
                allFriends.append(user)
            }
        }
        DispatchQueue.main.async {
            self.presenter?.setFriendListToView(users: allFriends)
        }
    }
    
    fileprivate func eventDbChildUpdate(_ roomID: String) {
        GrocDbManager.shared.usersUpdated(eventType: .childChanged) {(users) in
            self.friends = [User]()
            switch users {
            case .success(let user):
                self.friends.append(contentsOf: user)
                self.getFriends(userID: roomID)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    fileprivate func eventDbChildAdded(_ roomID: String) {
        GrocDbManager.shared.usersUpdated(eventType: .childAdded) {(users) in
            self.friends = [User]()
            switch users {
            case .success(let user):
                self.friends.append(contentsOf: user)
                self.getFriends(userID: roomID)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    fileprivate func eventDbChildRemoved(_ roomID: String) {
        GrocDbManager.shared.usersUpdated(eventType: .childRemoved) {(users) in
            self.friends = [User]()
            switch users {
            case .success(let user):
                self.friends.append(contentsOf: user)
                self.getFriends(userID: roomID)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

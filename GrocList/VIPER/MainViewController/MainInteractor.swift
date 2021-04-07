//
//  MainInteractor.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation

class MainInteractor: MainInteractorInputProtocol {
    var presenter: MainInteractorOutputProtocol?
    var friends = [User]()
    var friendsIds: [String] = []
    func getUsers(roomID: String) {
        eventDbChildAdded(roomID)
        eventDbChildUpdate(roomID)
        eventDbChildRemoved(roomID)
    }

    func getFriends(roomID: String) {
        GrocDbManager.shared.getUsersWithGrocs(roomKey: roomID) { status in
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
            self.presenter?.fetchedFriends(users: allFriends)
        }
    }
    
    fileprivate func eventDbChildUpdate(_ roomID: String) {
        GrocDbManager.shared.usersUpdated(eventType: .childChanged) {(users) in
            self.friends = [User]()
            switch users {
            case .success(let user):
                self.friends.append(contentsOf: user)
                self.getFriends(roomID: roomID)
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
                self.getFriends(roomID: roomID)
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
                self.getFriends(roomID: roomID)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

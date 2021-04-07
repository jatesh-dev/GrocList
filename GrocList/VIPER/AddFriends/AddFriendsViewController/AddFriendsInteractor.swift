//
//  AddFriendsInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class AddFriendsInteractor {
    var friendsIds: [String: String] = [:]
    var friends = [User]()
    weak var presenter: AddFriendsInteractorOutputProtocol?

    deinit {
        print("deinit AddFriendsInteractor")
    }
}

extension AddFriendsInteractor: AddFriendsInteractorInputProtocol {
    
    func getAllUsersFromDB(roomID: String) {
        eventDbChildAdded(roomID)
        eventDbChildUpdate(roomID)
        eventDbChildRemoved(roomID)
    }

    func getFriends(userID: String) {
        GrocDbManager.shared.checkRequests(roomKey: userID) { status in
            switch status {
            case .success(let friends):
                self.friendsIds = [:]
                for friend in friends {
                    self.friendsIds.updateValue(friend.value, forKey: friend.key)
                }
                self.sortFriends()
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
//
//    func sortFriends() {
//        var allFriends = [User]()
//        for user in friends {
//            if friendsIds.contains(user.userID) {
//                allFriends.append(user)
//            }
//        }
//        DispatchQueue.main.async {
//            self.presenter?.setFriendListToView(users: allFriends)
//        }
//    }
//
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

//    func getFriends(roomID: String) {
//        self.friends = [:]
//        GrocDbManager.shared.checkRequests(roomKey: roomID) { status in
//            switch status {
//            case .success(let friend):
//                self.friends = friend
//            case .failure(let error):
//                print("Error: ", error)
//            }
//        }
//    }
//
    func sortFriends() {
        var arr: [String] = []
        for friend in friendsIds where friend.value == "0" || friend.value == "1" || friend.value == "11" {
            arr.append(friend.key)
        }
        var suggestions = [User]()
        for user in friends {
            if arr.contains(user.userID!) {
                print("friend")
            } else {
                suggestions.append(user)
            }
        }
        presenter?.fetchedUsers(users: suggestions)
    }
}

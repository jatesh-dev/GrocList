//
//  FriendRequestsInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class FriendRequestsInteractor {
    
    weak var presenter: FriendRequestsInteractorOutputProtocol?
    var friends = [User]()
    var friendsIds = ["": ""]
    deinit {
        print("deinit FriendRequestsInteractor")
    }
}

extension FriendRequestsInteractor: FriendRequestsInteractorInputProtocol {
    func getAllRequestsFromDB(roomID: String) {
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
    
    func sortFriends() {
        var arr: [String] = []
        var requests = [User]()
        for friend in friendsIds where friend.value == "0" {
            arr.append(friend.key)
        }
        for user in friends where arr.contains(user.userID ?? "") {
            requests.append(user)
        }
        presenter?.fetchedFriendRequests(requests: requests)
    }
    
    func changeFriendRequestStatusIntoDB(accept: Bool, userID: String, roomKey: String) {
        if accept {
            GrocDbManager.shared.checkFriends(currentUserID: roomKey, secondUser: userID) { status in
                switch status {
                case .success:
                    GrocDbManager.shared.acceptRequests(roomKey: roomKey, userID: userID) { status in
                        switch status {
                        case .success:
                            print("Friend Added")
                            DispatchQueue.main.async {
                                self.getAllRequestsFromDB(roomID: roomKey)
                            }
                        case .failure(let error):
                            print("Error: ", error)
                        }
                    }
                case .failure(let error):
                    print("Error: ", error)
                }
            }
        } else {
            GrocDbManager.shared.declineRequest(roomKey: roomKey, userID: userID) { status in
                switch status {
                case .success:
                    print("Request Declined")
                    DispatchQueue.main.async {
                        self.getAllRequestsFromDB(roomID: roomKey)
                    }
                case .failure(let error):
                    print("Error: ", error)
                }
            }
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

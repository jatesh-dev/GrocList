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
    var users = [User]()
    var friends = ["": ""]
    deinit {
        print("deinit FriendRequestsInteractor")
    }
}

extension FriendRequestsInteractor: FriendRequestsInteractorInputProtocol {
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
                                self.getFriendRequests(roomID: roomKey)
                                self.getAllRequestsFromDB()
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
                        self.getFriendRequests(roomID: roomKey)
                        self.getAllRequestsFromDB()
                    }
                case .failure(let error):
                    print("Error: ", error)
                }
            }
        }
    }
    
    func getFriendRequests(roomID: String) {
        GrocDbManager.shared.checkRequests(roomKey: roomID) { status in
            switch status {
            case .success(let friend):
                self.friends = friend
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    func sortRequests() {
        var arr: [String] = []
        var requests = [User]()
        for friend in friends where friend.value == "0" {
            arr.append(friend.key)
        }
        for user in users where arr.contains(user.userID ?? "") {
            requests.append(user)
        }
        presenter?.fetchedFriendRequests(requests: requests)
    }
        
    func getAllRequestsFromDB() {
        self.users = [User]()
        GrocDbManager.shared.getAllUsers {(users) in
            switch users {
            case .success(let user):
                DispatchQueue.main.async {
                    self.users.append(contentsOf: user)
                    self.sortRequests()
                }
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
 }

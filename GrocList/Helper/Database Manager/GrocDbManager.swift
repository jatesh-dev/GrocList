//
//  GrocDbManager.swift
//  GrocList
//
//  Created by Jatesh Kumar on 10/03/2021.
//

import Foundation
import Firebase
import FirebaseUI
import FirebaseStorage

class GrocDbManager {
    
    private let dbReference: DatabaseReference
    private let storageReference: StorageReference
    static let shared = GrocDbManager()
    
    var grocData = [Grocs]()
    var doneData = [Grocs]()
    var user = [User]()
    var grocs = [Grocs]()
    var countDictionary = ["total": "0", "todo": "0", "done": "0", "unread": "0", "time": "0"]
    var isGrocRoomCreated = false
    var isFriend = false
    var roomCount: Int = 0
    var friendCount: Int = 0
    var count = 0
    var seenStatus: String = "unchange"
    
    init() {
        dbReference = Database.database().reference()
        storageReference = Storage.storage().reference()
    }
    
    /****GROC VIEW CONTROLLER**/
    func setGrocItem(data: Grocs, roomKey: String?) {
        let currentTime = NSDate().description
        var grocData: [String: String?]
        grocData = [ "name": data.grocName,
                     "description": data.grocDescription,
                     "assigneeID": data.grocAssigneeID,
                     "status": data.status,
                     "timestamp": currentTime,
                     "seenStatus": "0" ]
        guard let roomKey = roomKey else { return }
        self.dbReference.child("GrocList").child(roomKey ).child("grocs").childByAutoId().updateChildValues(grocData as [AnyHashable: Any])
    }
    
    func getTodoGrocItems(grocKey: String, seenStatus: String, completion: @escaping (Result<[Grocs], Error>) -> Void) {
        dbReference.child("GrocList").child(grocKey).child("grocs").getData { (error, snapshot) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let newSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                print("GetToDoList Count: ", self.grocData.count)
                DispatchQueue.main.async {
                    self.grocData = [Grocs]()
                    for snap in newSnapshot {
                        if var dictionary = snap.value as? [String: AnyObject] {
                            print("Jatesh: ", dictionary)
                            dictionary["id"] = snap.key as AnyObject
                            self.grocData.append(Grocs(data: dictionary))
                            if dictionary["assigneeID"] as? String != Auth.auth().currentUser?.uid && seenStatus == "change" {
                                self.dbReference.child("GrocList").child(grocKey).child("grocs").child(snap.key).updateChildValues(["seenStatus": "1"])
                            }
                        }
                    }
                    completion(.success(self.grocData))
                }
            }
        }
    }
    
    func grocItemChanged(eventType: DataEventType, grocKey: String, completion: @escaping (Result<[Grocs], Error>) -> Void ) {
        self.dbReference.child("GrocList").child(grocKey).observe(eventType, with: { _ in
            if eventType == .childAdded {
                self.seenStatus = "change"
            }
            self.getTodoGrocItems(grocKey: grocKey, seenStatus: self.seenStatus) {(data) in
                self.grocData = [Grocs]()
                switch data {
                case .success(let data):
                    data.forEach({ (data) in
                        self.grocData.append(data)
                    })
                    completion(.success(self.grocData))
                case .failure(let error):
                    print("Error: ", error)
                    completion(.failure(error))
                }
            }
            self.seenStatus = "unchange"
        })
    }
    
    func getAssigneeName(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.dbReference.child("users").getData { (_, snapshot) in
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                DispatchQueue.main.async {
                    for data in snap where  data.key == uid {
                        if let dictionary = data.value as? [String: AnyObject] {
                            guard let name: String = dictionary["name"] as? String else { return }
                            completion(.success(name))
                        }
                    }
                }
            }
        }
    }
    
    func updateGrocStatus (roomId: String, status: String, grocKey: String?) -> Bool {
        guard let grocKey = grocKey else {
            return false
        }
        self.dbReference.child("GrocList").child(grocKey).child("grocs").observe(.childAdded, with: {(snapshot) in
            if roomId == snapshot.key {
                self.dbReference.child("GrocList").child(grocKey).child("grocs").child(roomId).updateChildValues(["status": status])
            }
        }, withCancel: nil)
        return true
    }
    
    func updateGrocDesc (roomId: String, description: String, grocKey: String?) -> Bool {
        guard let grocKey = grocKey else {
            return false
        }
        self.dbReference.child("GrocList").child(grocKey).child("grocs").observe(.childAdded, with: {(snapshot) in
            if roomId == snapshot.key {
                self.dbReference.child("GrocList").child(grocKey).child("grocs").child(roomId).updateChildValues(["description": description])
            }
        }, withCancel: nil)
        return true
    }
    
    func deleteGroc (roomId: String, grocKey: String?) -> Bool {
        guard let grocKey = grocKey else {
            return false
        }
        self.dbReference.child("GrocList").child(grocKey).child("grocs").child(roomId).removeValue()
        return true
    }
    
    /****MAIN VIEW CONTROLLER**/
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        user = [User]()
        self.dbReference.child("users").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if let newSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.user = [User]()
                DispatchQueue.main.async {
                    for snap in newSnapshot {
                        if var dictionary = snap.value as? [String: AnyObject] {
                            if snap.key == Auth.auth().currentUser?.uid {
                                print("My dictionary: ", dictionary)
                            } else {
                                dictionary["id"] = snap.key as AnyObject
                                self.user.append(User(data: dictionary))
                            }
                        }
                    }
                    completion(.success(self.user))
                }
            } else {
                print("No data available")
            }
        }
    }
    
    func checkRequests(roomKey: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        self.dbReference.child("users").child(roomKey).child("friends").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else {
                var dataArray: [String: String] = [:]
                if let data = snapshot.children.allObjects as? [DataSnapshot] {
                    data.forEach { (data) in
                        let key: String = data.key
                        let value: String = data.value as? String ?? ""
                        dataArray.updateValue(value, forKey: key)
                    }
                    DispatchQueue.main.async {
                        completion(.success(dataArray))
                    }
                }
            }
        }
    }
    
    func getUsersWithGrocs(roomKey: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        self.dbReference.child("users").child(roomKey).child("grocRoom").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else {
                var grocArray: [String: String] = [:]
                if let data = snapshot.children.allObjects as? [DataSnapshot] {
                    data.forEach { (data) in
                        let key: String = data.key
                        let value: String = data.value as? String ?? ""
                        grocArray.updateValue(value, forKey: key)
                    }
                    DispatchQueue.main.async {
                        completion(.success(grocArray))
                    }
                }
            }
        }
    }
    
    func acceptRequests(roomKey: String, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.dbReference.child("users").child(roomKey).child("friends").updateChildValues([userID: "11"]) { _, _ in
            self.dbReference.child("users").child(userID).child("friends").updateChildValues([roomKey: "11"]) { _, _ in
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            }
        }
    }
    
    func declineRequest(roomKey: String, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.dbReference.child("users").child(roomKey).child("friends").child(userID).removeValue()
        self.dbReference.child("users").child(userID).child("friends").child(roomKey).removeValue()
        DispatchQueue.main.async {
            completion(.success(true))
        }
    }
    
    func checkGrocroom(currentUserID: String?, secondUser: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let current = currentUserID, let second = secondUser else {
            return
        }
        let roomUsers = [
            "user 1": current,
            "user 2": second
        ]
        isGrocRoomCreated = false
        self.dbReference.child("users").child(current).child("grocRoom").getData { (_, currentUserSnapshot) in
            self.dbReference.child("users").child(second).child("grocRoom").getData { (_, secondUserSnapshot) in
                if let currentUserSnap = currentUserSnapshot.children.allObjects as? [DataSnapshot] {
                    if let secondUserSnap = secondUserSnapshot.children.allObjects as? [DataSnapshot] {
                        for currentUser in currentUserSnap {
                            for second in secondUserSnap {
                                guard let currentuser = currentUser.value as? String, let seconduser = second.value as? String else { return }
                                if currentuser == seconduser {
                                    guard let key = currentUser.value as? String else { return }
                                    completion(.success(key))
                                    self.isGrocRoomCreated = true
                                }
                            }
                        }
                    }
                }
                if self.isGrocRoomCreated == false {
                    guard let grocRoomId = self.dbReference.child("GrocList").childByAutoId().key else {
                        return
                    }
                    self.roomCount = 0
                    
                    let roomData1 = [second: grocRoomId]
                    self.dbReference.child("GrocList").child(grocRoomId).child("users").updateChildValues(roomUsers as [String: Any])
                    self.dbReference.child("users").child(current).child("grocRoom").updateChildValues(roomData1 as [String: Any])
                    self.roomCount = 0
                        
                    // Second User ID
                    let roomData2 = [current: grocRoomId]
                    self.dbReference.child("users").child(second).child("grocRoom").updateChildValues(roomData2 as [String: Any]) { _, _ in
                        DispatchQueue.main.async {
                            completion(.success(grocRoomId))
                        }
                    }
                }
            }
        }
    }
    
    func checkFriends(currentUserID: String?, secondUser: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let current = currentUserID, let second = secondUser else {
            return
        }
        self.friendCount = 0
        self.dbReference.child("users").child(current).child("friends").getData {(_, snapshot) in
            self.friendCount += snapshot.children.allObjects.count
            let friend = [second: "1"]
            self.dbReference.child("users").child(current).child("friends").updateChildValues(friend as [String: Any])
            self.friendCount = 0
            
            // Second User ID
            self.dbReference.child("users").child(second).child("grocRoom").getData {(_, snapshot) in
                self.friendCount += snapshot.children.allObjects.count
                let friend = [current: "0"]
                self.dbReference.child("users").child(second).child("friends").updateChildValues(friend as [String: Any]) { _, _ in
                    DispatchQueue.main.async {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    func getGrocs(currentUserID: String?, secondUserID: String?, completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let current = currentUserID, let second = secondUserID else {
            return
        }
        self.grocs = [Grocs]()
        self.dbReference.child("users").child(current).child("grocRoom").getData {(error, currentUserSnapshot) in
            self.dbReference.child("users").child(second).child("grocRoom").getData {(error, secondUserSnapshot) in
                if let currentUserSnap = currentUserSnapshot.children.allObjects as? [DataSnapshot] {
                    if let secondUserSnap = secondUserSnapshot.children.allObjects as? [DataSnapshot] {
                        for current in currentUserSnap {
                            for second in secondUserSnap {
                                guard let currentU = current.value as? String, let secondU = second.value as? String else {
                                    return
                                }
                                if currentU == secondU {
                                    let room = currentU
                                    self.getTodoGrocItems(grocKey: room, seenStatus: self.seenStatus) {(data) in
                                        switch data {
                                        case .success(let data):
                                            self.countDictionary = ["total": "0", "todo": "0", "done": "0", "unread": "0", "time": "0"]
                                            var countUnread = 0
                                            var countDone = 0
                                            var countTotal = 0
                                            var countTodo = 0
                                            data.forEach({data in
                                                if data.grocAssigneeID != currentUserID {
                                                    if data.seenStatus == "0"{
                                                        countUnread += 1
                                                    }
                                                }
                                                if data.status == "0" {
                                                    countDone += 1
                                                } else {
                                                    countTodo += 1
                                                }
                                            })
                                            countTotal = data.count
                                            self.countDictionary["total"] = String(countTotal)
                                            guard let timestamp = data.last?.timestamp else {
                                                completion(.success(self.countDictionary))
                                                return
                                            }
                                            self.countDictionary["todo"] = String(countTodo)
                                            self.countDictionary["done"] = String(countDone)
                                            self.countDictionary["unread"] = String(countUnread)
                                            self.countDictionary["time"] = timestamp
                                            completion(.success(self.countDictionary))
                                        case .failure(let error):
                                            print("Error: ", error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func grocItemsUpdated(currentUserID: String?, secondUserID: String?, eventType: DataEventType, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        self.dbReference.child("GrocList").observe(eventType, with: {_ in
            self.getGrocs(currentUserID: currentUserID, secondUserID: secondUserID) {(data) in
                switch data {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print("Error: ", error)
                }
            }
        })
    }
    
    func getProfilePicture(userID: String, completion: @escaping (Result<URL, Error>) -> Void) {
        storageReference.child("ProfilePhotos").child(userID).downloadURL {(url, _) in
            DispatchQueue.main.async {
                guard let url = url else { return }
                completion(.success(url))
            }
        }
    }
    
    // Register New User
    func createUser(email: String, password: String, name: String, imageUrl: URL, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error != nil {
                print(error as Any)
                return
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { (error) in
                    print("ERROR: ", error as Any)
                }
                print("User Created")
                // Saving user into db
                let userID = Auth.auth().currentUser?.uid ?? ""
                let userRef = self.dbReference.child("users").child(userID)
                
                let values = ["name": name, "email": email]
                userRef.updateChildValues(values) { (error, _) in
                    if error != nil {
                        print(error as Any)
                        completion(.failure(error!))
                    }
                    self.uploadProfilePicture(fileUrl: imageUrl, uid: userID)
                    print("Saved user data in DB")
                    completion(.success(true))
                }
            }
        }
    }
    
    func uploadProfilePicture (fileUrl: URL, uid: String) {
        let storageReference = Storage.storage().reference()
        let upload = storageReference.child("ProfilePhotos").child(uid).putFile(from: fileUrl, metadata: nil) { (metadata, err) in
            guard metadata != nil else {
                print(err!.localizedDescription)
                return
            }
            print("Image Uploaded")
        }
        print("Upload Returns: ", upload)
    }
}

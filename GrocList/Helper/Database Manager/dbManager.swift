//
//  dbManager.swift
//  GrocList
//
//  Created by Syed Asad on 10/03/2021.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseUI

class DbManager {
	
	static let shared = DbManager()
	var dbReference = DatabaseReference.init()
	var msg = [Messages]()
	var users = [User]()
	var isChatRoomCreated: Bool = false
	var roomCount: Int = 1
	
	init() {
		self.dbReference = Database.database().reference()
	}
	
	/****CHAT SCREEN**/
	func observer(event: DataEventType, chatKey: String, completion: @escaping (Result<[Messages], Error>) -> Void) {
		self.dbReference.child("GrocList").child(chatKey).observe(event, with: { (_) in
			self.dbReference.child("GrocList").child(chatKey).child("messages").getData { (error, snapMessages) in
				if snapMessages.children.allObjects is [DataSnapshot] {
					self.getData(chatKey: chatKey) { (data) in
						self.msg = [Messages]()
						switch data {
						case .success(let data):
							data.forEach({ (data) in
								self.msg.append(data)
							})
							completion(.success(self.msg))
						case .failure(let error):
							print("Error: ", error)
							completion(.failure(error))
						}
					}
				}
			}
		})
	}
	
	func getData(chatKey: String, completion: @escaping (Result<[Messages], Error>) -> Void) {
		self.dbReference.child("GrocList").child(chatKey).child("messages").getData {(_, snapMessages) in
			if let messages = snapMessages.children.allObjects as? [DataSnapshot] {
				DispatchQueue.main.async {
					self.msg = [Messages]()
					for allMessages in messages {
						if let dictionary = allMessages.value as? [String: AnyObject] {
							print(dictionary["msg"] as Any)
							self.msg.append(Messages(data: dictionary))
						}
					}
					completion(.success(self.msg))
				}
			}
		}
	}

	func sendMessage(chatKey: String, values: [String: Any]) {
		dbReference.child("GrocList").child(chatKey).child("messages").childByAutoId().updateChildValues(values as [AnyHashable: Any]) { (_, dbReference) in
			dbReference.child("GrocList").child(chatKey).observe(.childChanged, with: { (_) in
			})
		}
	}
	
	/****CONTACT SCREEN**/
//	func checkAndCreateChatRoom(user: User, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let fromID = Auth.auth().currentUser?.uid, let toID = user.userID  else {
//			print("CURRENT USER")
//			return
//		}
//		self.isChatRoomCreated = false
//		let dictionaryID = ["user1": fromID, "user2": toID]
//
//		self.dbReference.child("ChatRoom").getData { (_, snapShotChatRoom) in
//			self.dbReference.child("users").child(toID).child("myRoom").getData { (_, snapShotUserRoom) in
//				self.dbReference.child("users").child(fromID ).child("myRoom").getData { (_, snapShotCurrentUserChatRoom) in
//
//					if let snapChat = snapShotChatRoom.children.allObjects as? [DataSnapshot] {
//						if let snapUserChat = snapShotUserRoom.children.allObjects as? [DataSnapshot] {
//							if let snapCurrentUserChat = snapShotCurrentUserChatRoom.children.allObjects as? [DataSnapshot] {
//
//								for chat in snapChat {
//									for userRoom in snapUserChat {
//										/****IF ROOM IS ALREADY CREATED**/
//										guard let userRoomValue = userRoom.value as? String else { return }
//										if chat.key == userRoomValue {
//											for currentUserRoom in snapCurrentUserChat {
//												guard let currentUserRoomValue = currentUserRoom.value as? String else { return }
//												if chat.key == currentUserRoomValue {
//													self.isChatRoomCreated = true
//													completion(.success(chat.key))
//												}
//											}
//										}
//									}
//								} /***nestedfor*/
//							}
//						}
//					} /***nested if**/
//					/****IF NO ROOM**/
//					if self.isChatRoomCreated == false {
//						guard let refChatRoom = self.dbReference.child("ChatRoom").childByAutoId().key else {
//							return
//						}
//						// ToUser
//						self.roomCount = 1
//						self.dbReference.child("users").child(toID ).child("myRoom").getData { (_, snapForCount) in
//							self.roomCount += snapForCount.children.allObjects.count
//							let countTo: String = String(self.roomCount)
//							self.dbReference.child("ChatRoom").child(refChatRoom).child("users").updateChildValues(dictionaryID )
//							let dictionaryUserRoom = [countTo: "\(refChatRoom)"]
//							self.dbReference.child("users").child(toID ).child("myRoom").updateChildValues(dictionaryUserRoom)
//							self.roomCount = 1
//						}
//						// fromUser
//						self.roomCount = 1
//						self.dbReference.child("users").child(fromID ).child("myRoom").getData { (_, snapForCount) in
//							self.roomCount += snapForCount.children.allObjects.count
//							let countFrom: String = String(self.roomCount)
//							let dictionaryUserRoom = [countFrom: "\(refChatRoom)"]
//							self.dbReference.child("users").child(fromID).child("myRoom").updateChildValues(dictionaryUserRoom)
//							self.roomCount = 1
//						}
//						completion(.success(refChatRoom))
//					}
//				}
//			}/**chatRoomClose*/
//		}
//	}
	
//	func fetchUserData(completion: @escaping (Result<[User], Error>) -> Void) {
//		users = [User]()
//		self.dbReference.child("users").observe(.childAdded, with: { (snapshot) in
//			if var dictionary = snapshot.value as? [String: AnyObject] {
//				dictionary["id"] = snapshot.key as AnyObject
//				print(dictionary)
//				if dictionary["id"] as? String != Auth.auth().currentUser?.uid {
//					self.users.append(User(data: dictionary))
//				}
//				completion(.success(self.users))
//			}
//		}, withCancel: nil)
//	}
}

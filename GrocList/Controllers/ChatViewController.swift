//
//  ChatLogViewController.swift
//  GrocList
//
//  Created by Syed Asad on 24/02/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

class ChatViewController: UIViewController {
	
	var roomCount: Int = 1
	var isChatRoomCreated: Bool = false
	var dbReference = DatabaseReference.init()
	var user: User?
	let time = NSDate().description
	let fromID = Auth.auth().currentUser?.uid
	var msg = [Messages]()
	var activityView: UIActivityIndicatorView?
	var chatroomKey: String?
	var storageReference = Storage.storage().reference()
	// OUTLETS
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var fieldTypeMessage: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dbReference = Database.database().reference()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		fieldTypeMessage.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		showActivityIndicator()
		registerCellForChat()
		attributedNavigation()
		self.hideKeyboardWhenTappedAround()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.loadMessages()
		print("ChatRoom Key: ", chatroomKey ?? "")
		if !self.msg.isEmpty {
			self.tableView.scrollToRow(at: IndexPath(row: (self.msg.count - 1), section: 0), at: .bottom, animated: true)
		}
		self.tableView.reloadData()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@IBAction func buttonActionSendMessage(_ sender: Any) {
		guard let currentID = Auth.auth().currentUser?.uid, let msg = fieldTypeMessage.text, let chatKey = chatroomKey else {
			return
		}
		if fieldTypeMessage.text != nil {
			print(fieldTypeMessage.text ?? "")
			let values = ["fromID": currentID,
						  "msg": msg,
						  "time": time] as [String: Any]
			DispatchQueue.main.async {
				DbManager.shared.sendMessage(chatKey: chatKey, values: values)
				self.loadMessages()
				self.tableView.reloadData()
				if !self.msg.isEmpty {
					self.tableView.scrollToRow(at: IndexPath(row: (self.msg.count - 1), section: 0), at: .bottom, animated: true)
				}
			}
		}
		fieldTypeMessage.text = ""
	}
}

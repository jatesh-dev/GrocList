//
//  Extension.swift
//  GrocList
//
//  Created by Syed Asad on 11/03/2021.
//

import UIKit

extension ChatViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
	
	fileprivate func eventDBChildAdded() {
		guard let chatKey = self.chatroomKey else {
			return
		}
		DbManager.shared.observer(event: .childAdded, chatKey: chatKey) { (data) in
			switch data {
			case .success(let data):
				self.msg = [Messages]()
				data.forEach({ (data) in
					self.msg.append(data)
				})
			case .failure(let error):
				print("Error: ", error)
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
				if !self.msg.isEmpty {
					self.tableView.scrollToRow(at: IndexPath(row: (self.msg.count - 1), section: 0), at: .bottom, animated: true)
				}
			}
		}
	}
	
	fileprivate func eventDBChildChanged() {
		guard let chatKey = self.chatroomKey else { return }
		DbManager.shared.observer(event: .childChanged, chatKey: chatKey) { (data) in
			switch data {
			case .success(let data):
				self.msg = [Messages]()
				data.forEach({ (data) in
					self.msg.append(data)
				})
			case .failure(let error):
				print("Error: ", error)
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
				if !self.msg.isEmpty {
					self.tableView.scrollToRow(at: IndexPath(row: (self.msg.count - 1), section: 0), at: .bottom, animated: true)
				}
			}
		}
	}
	
	func loadMessages() {
		eventDBChildChanged()
		eventDBChildAdded()
		if !self.msg.isEmpty {
			self.tableView.scrollToRow(at: IndexPath(row: (self.msg.count - 1), section: 0), at: .bottom, animated: true)
			tableView.reloadData()
		}
		tableView.reloadData()
		hideActivityIndicator()
	}
	
	func registerCellForChat() {
		let nibCell = UINib(nibName: "ViewRecievedCell", bundle: nil)
		tableView.register(nibCell, forCellReuseIdentifier: "receivedMessage")
		let nibCellSent = UINib(nibName: "ViewSentCell", bundle: nil)
		tableView.register(nibCellSent, forCellReuseIdentifier: "sentMessage")
	}
	
	// ActivityIndicator
	func showActivityIndicator() {
		activityView = UIActivityIndicatorView(style: .large)
		activityView?.center = self.view.center
		self.tableView.addSubview(activityView!)
		activityView?.startAnimating()
	}
	
	func hideActivityIndicator() {
		if activityView != nil {
			activityView?.stopAnimating()
		}
	}
	
	// setTimeandDate
	func setTimeDateFormat (data: String) -> [String: String] {
		let getFormatter = DateFormatter()
		getFormatter.calendar = Calendar(identifier: .iso8601)
		getFormatter.locale = Locale(identifier: "es")
		getFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss zzzzz"
		let timeFormatter = DateFormatter()
		timeFormatter.timeStyle = .short
		timeFormatter.dateFormat = "hh:mm a"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy"
		print(data)
		if let dateTime = getFormatter.date(from: data) {
			let time = timeFormatter.string(from: dateTime)
			let date = dateFormatter.string(from: dateTime)
			print("Check: ", date)
			return ["time": time, "date": date]
		} else {
			return ["": ""]
		}
	}
	
	// Keyboard
	func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		self.tableView.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@objc func keyboardWillShow(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= (keyboardSize.height - self.view.safeAreaInsets.bottom)
			}
		}
	}
	
	@objc func keyboardWillHide(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0 {
				self.view.frame.origin.y += (keyboardSize.height - self.view.safeAreaInsets.bottom)
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	// NavBar back Action
	@objc func leftHandAction() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func attributedNavigation() {
		navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09019607843, green: 0.3568627451, blue: 0.6196078431, alpha: 1)
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor .white]
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backButtonIcon"), style: .plain, target: self, action: #selector(leftHandAction))
		navTitleAndImage(user?.name ?? "")
	}
	
	// Setting image and title on Navigation Bar
	func navTitleAndImage(_ title: String) {
		let titleLbl = UILabel()
		titleLbl.text = title
		titleLbl.textColor = UIColor.white
		titleLbl.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
		
		let imageView = UIImageView()
		storageReference.child("ProfilePhotos").child(user?.userID ?? "").downloadURL { (url, _) in
			imageView.sd_setImage(with: url)
		}
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		imageView.layer.cornerRadius = 20
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 0.2
		imageView.contentMode = UIView.ContentMode.scaleAspectFill
		imageView.backgroundColor = .white
		
		let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
		titleView.contentMode = .center
		titleView.axis = .horizontal
		titleView.spacing = 5
		navigationItem.titleView = titleView
	}
	
	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return msg.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = msg[indexPath.row]
		let timeMessage = setTimeDateFormat(data: message.time!)
		if message.fromID != self.fromID {
			guard let cellReceivedMessage = tableView.dequeueReusableCell(withIdentifier: "receivedMessage", for: indexPath) as? TableViewCellReceivedMessages else {
				return UITableViewCell()
			}
			cellReceivedMessage.labelReceivedMessages.text = message.msg
			cellReceivedMessage.viewReceivedMessages.layer.cornerRadius = 8.0
			cellReceivedMessage.viewReceivedMessages.layer.borderWidth = 0.1
			cellReceivedMessage.labelTimeReceive.text = timeMessage["time"]
			storageReference.child("ProfilePhotos").child(self.user?.id ?? "").downloadURL { (url, _) in
				cellReceivedMessage.imageProfile.sd_setImage(with: url)
			}
			return cellReceivedMessage
		} else {
			guard let cellSentMessage = tableView.dequeueReusableCell(withIdentifier: "sentMessage", for: indexPath) as? TableViewCellSentMessages else {
				return UITableViewCell()
			}
			cellSentMessage.labelSentMessages.text = message.msg
			cellSentMessage.viewSentMessages.layer.cornerRadius = 8.0
			cellSentMessage.viewSentMessages.layer.borderWidth = 0.1
			cellSentMessage.labelTimeSent.text = timeMessage["time"]
			return cellSentMessage
		}
	}
}

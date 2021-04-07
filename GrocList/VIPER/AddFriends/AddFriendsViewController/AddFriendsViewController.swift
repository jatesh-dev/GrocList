//
//  AddFriendsViewController.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AddFriendsViewController: UIViewController {

	var presenter: AddFriendsPresenterProtocol?
    var suggestions = [User]()
    let spinner = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var tableView: UITableView!
    deinit {
        print("deinit AddFriendsViewController")
    }
    var currentUserID: String = ""

	override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID: String = Auth.auth().currentUser?.uid else { return }
        self.currentUserID = userID
        presenter?.getFriendList(userID: userID)
        presenter?.getAllUsersExceptFriends()
        
        tableView.delegate = self
        tableView.dataSource = self
        register()
    }
    
    func register() {
        let nib = UINib(nibName: "AddFriendCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "addFriendCell")
    }
}

extension AddFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendCell", for: indexPath) as? AddFriendCell else { return UITableViewCell() }
        cell.imageViewProfilePicture.image = nil
        GrocDbManager.shared.getProfilePicture(userID: suggestions[indexPath.row].userID ?? "") {(status) in
            switch status {
            case .success(let url):
                cell.imageViewProfilePicture.kf.indicatorType = .activity
                cell.imageViewProfilePicture.kf.setImage(with: url)
            case .failure(let error):
                print("Storage Error: ", error)
            }
        }
        cell.delegate = self
        cell.configure(user: suggestions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

extension AddFriendsViewController: AddFriendsViewProtocol, AddFriendCellDelegate {
    func didAddFriend(userID: String) {
        self.showLoader()
        addFriend(currentUserID: self.currentUserID, secondUser: userID)
    }
    
    func setupUsers(users: [User]) {
        self.suggestions = [User]()
        self.suggestions.append(contentsOf: users)
        DispatchQueue.main.async {
            self.hideLoader()
            self.tableView.reloadData()
        }
    }
    
    func showLoader() {
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func hideLoader() {
        spinner.stopAnimating()
    }
    
    func addFriend(currentUserID: String, secondUser: String) {
        GrocDbManager.shared.checkFriends(currentUserID: currentUserID, secondUser: secondUser) {(result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.presenter?.getFriendList(userID: self.currentUserID)
                    self.presenter?.getAllUsersExceptFriends()
                }
            case .failure(let error):
                print("Error Occured: ", error)
            }
        }
    }
}

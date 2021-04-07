//
//  FriendListViewController.swift
//  GrocList
//
//  Created Jatesh Kumar on 05/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FriendListViewController: UIViewController {

	var presenter: FriendListPresenterProtocol?
    var friends = [User]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoFriends: UILabel!
    var currenUserID: String = ""
    var grocKey: String = ""
    let spinner = UIActivityIndicatorView(style: .large)
    deinit {
        print("deinit FriendListViewController")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader()
        labelNoFriends.isHidden = true
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.currenUserID = userID
        presenter?.getMyFriendList(myUserID: userID)
        tableView.dataSource = self
        tableView.delegate = self
        register()
    }
    
    func register() {
        let nib = UINib(nibName: "FriendListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "friendListCell")
    }
    
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as? FriendListCell else { return UITableViewCell() }
        cell.imageViewProfilePicture.image = nil
        GrocDbManager.shared.getProfilePicture(userID: friends[indexPath.row].userID ?? "") {(status) in
            switch status {
            case .success(let url):
                cell.imageViewProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "user"))
            case .failure(let error):
                print("Storage Error: ", error)
            }
        }
        cell.configure(user: friends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GrocDbManager.shared.checkGrocroom(currentUserID: self.currenUserID, secondUser: friends[indexPath.row].userID) {(key) in
            switch key {
            case .success(let key):
                self.grocKey = key
            case .failure(let error):
                print("Error Occured: ", error)
            }
            DispatchQueue.main.async {
                let grocViewController = GrocViewRouter.createModule(grockKey: self.grocKey, secondUser: self.friends[indexPath.row])
                let nav = UINavigationController()
                nav.viewControllers = [grocViewController]
                self.navigationController?.pushViewController(grocViewController, animated: true)
            }
        }
    }
}

extension FriendListViewController: FriendListViewProtocol {
    func updateView(friends: [User]) {
        self.friends = friends
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if friends.count > 0 {
                self.labelNoFriends.isHidden = true
            } else {
                self.labelNoFriends.isHidden = false
            }
            self.hideLoader()
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
}

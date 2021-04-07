//
//  FriendRequestsViewController.swift
//  GrocList
//
//  Created Jatesh Kumar on 01/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoFriendRequests: UILabel!
    var presenter: FriendRequestsPresenterProtocol?
    var friendRequests = [User]()
    var currentUserID: String = ""
    let spinner = UIActivityIndicatorView(style: .large)
    deinit {
        print("deinit FriendRequestsViewController")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader()
        tableView.delegate = self
        tableView.dataSource = self
        register()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.currentUserID = userID
        
        presenter?.getAllFriendRequests(roomID: currentUserID)
    }
    
    func register() {
        let nib = UINib(nibName: "RequestCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "requestCell")
    }
}

extension FriendRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as? RequestCell else { return UITableViewCell() }
        GrocDbManager.shared.getProfilePicture(userID: friendRequests[indexPath.row].userID ?? "") {(status) in
            switch status {
            case .success(let url):
                cell.imageViewProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "user"))
            case .failure(let error):
                print("Storage Error: ", error)
            }
        }
        cell.delegate = self
        cell.configure(user: friendRequests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

extension FriendRequestsViewController: FriendRequestsViewProtocol, RequestCellDelegate {
    func setupRequests(requests: [User]) {
        self.friendRequests = requests
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.friendRequests.count > 0 {
                self.labelNoFriendRequests.isHidden = true
            } else {
                self.labelNoFriendRequests.isHidden = false
            }
            self.hideLoader()
        }
    }
    
    func friendRequest(accept: Bool, userID: String) {
        presenter?.changeFriendRequestStatus(accept: accept, userID: userID, roomKey: currentUserID)
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

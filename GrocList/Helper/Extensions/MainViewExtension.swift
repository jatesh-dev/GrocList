//
//  MainViewExtension.swift
//  GrocList
//
//  Created by Jatesh Kumar on 11/03/2021.
//

import UIKit
import Firebase

extension MainViewController: UITableViewDelegate, UITableViewDataSource, MainViewProtocol {
    func checkFriends(userID: [String]) {
        self.friends.append(contentsOf: userID)
    }
    
    func updateView(users: [User]) {
        self.friendList = [User]()
        for user in users {
            if friends.contains(user.userID!) {
                friendList.append(user)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideActivityIndicator()
            if self.friendList.count > 0 {
                self.labelNoGrocsFound.isHidden = true
            } else {
                self.labelNoGrocsFound.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.text = "Add New Friends"
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? MainUserCell else { return UITableViewCell() }
        cell.labelName.text = friendList[indexPath.row].name
        GrocDbManager.shared.getProfilePicture(userID: friendList[indexPath.row].userID ?? "") {(status) in
            switch status {
            case .success(let url):
                cell.imageViewProfilePicture.sd_setImage(with: url)
            case .failure(let error):
                print("Storage Error: ", error)
            }
        }
        guard let userId = currentUserID else { return UITableViewCell()}
        GrocDbManager.shared.grocItemsUpdated(currentUserID: userId, secondUserID: friendList[indexPath.row].userID, eventType: .value) { (status) in
            switch status {
            case .success(let count):
                guard let total = count["total"], let done = count["done"], let todo = count["todo"], let unread = count["unread"] as? String else { return }
                
                guard let timestamp = count["time"] as? String else { return }
                cell.labelGrocStatus.text = "Items: \(total) | Done: \(done) | Pending: \(todo)"
                if unread != "0" {
                    cell.buttonUnreadCount.isHidden = false
                    cell.buttonUnreadCount.setTitle(String(unread), for: .normal)
                }
                if unread == "0" {
                    cell.buttonUnreadCount.isHidden = true
                }
                let dateTime = CommonFunctions.shared.setTimeDateFormat(data: timestamp)
                cell.labelTime.text = dateTime["time"]
            case .failure(let error):
                print("Error: ", error)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        GrocDbManager.shared.checkGrocroom(currentUserID: currentUserID, secondUser: friendList[indexPath.row].userID) {(key) in
            switch key {
            case .success(let key):
                self.key = key
            case .failure(let error):
                print("Error Occured: ", error)
            }
            DispatchQueue.main.async {
                let grocViewController = GrocViewRouter.createModule(grockKey: self.key)
                let nav = UINavigationController()
                nav.viewControllers = [grocViewController]
                self.navigationController?.pushViewController(grocViewController, animated: true)
            }
        }
    }
}

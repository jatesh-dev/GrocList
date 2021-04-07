//
//  MenuListController.swift
//  GrocList
//
//  Created by Jatesh Kumar on 11/03/2021.
//

import UIKit
import Firebase

class MenuListController: UITableViewController {
    
    let profileIcon = UIImage(imageLiteralResourceName: "profile.png")
    let contactsIcon = UIImage(imageLiteralResourceName: "contacts.png")
    let settingsIcon = UIImage(imageLiteralResourceName: "settings.png")
    let termsIcon = UIImage(imageLiteralResourceName: "terms.png")
    let privacyIcon = UIImage(imageLiteralResourceName: "privacy.png")
    let logoutIcon = UIImage(imageLiteralResourceName: "logoutIcon.png")
    var name = ""
    var email = ""
    var items: [String] = []
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userName = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email else {return}
        self.name = userName
        self.email = userEmail
        
        items = [self.name, "Profile", "Contacts", "Settings", "Terms & Conditions", "Privacy Policy", "LOGOUT"]
        images = [profileIcon, contactsIcon, settingsIcon, termsIcon, privacyIcon, logoutIcon]
        navigationController?.setNavigationBarHidden(true, animated: true)
        registerCell()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
    }
    
    func registerCell () {
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuCell")
        let nib2 = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "profileCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell()
            }
            cell.profileNameLabel.text = items[indexPath.row]
            cell.profileEmailLabel.text = self.email
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell else { return UITableViewCell() }
            cell.menuTitleLabel.text = items[indexPath.row]
            cell.iconImageView.image = images[indexPath.row-1]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let subModules = (
                requests: FriendRequestsRouter.createModule(),
                suggestions: AddFriendsRouter.createModule(),
                friendList: FriendListRouter.createModule()
            )
            let tabBarController = FriendsTabBarModuleBuilder.build(usingSubModules: subModules)
            if let navigator = self.navigationController {
                navigator.pushViewController(tabBarController, animated: true)
            }
        }
        if indexPath.row == 6 {
            self.logoutUser()
        }
    }
    
    private func logoutUser() {
        let alert = UIAlertController(title: "Are You Sure", message: "Do you really want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            let home = LoginRouter.createModule()
            let nav = UINavigationController()
            nav.viewControllers = [home]
            self.navigationController?.pushViewController(home, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

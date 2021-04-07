//
//  FriendsTabBarController.swift
//  GrocList
//
//  Created by Jatesh Kumar on 01/04/2021.
//

import UIKit

typealias FriendsTabs = (
    requests: UIViewController,
    suggestions: UIViewController,
    friendList: UIViewController
)

class FriendsTabBarController: UITabBarController {

    init (tabs: FriendsTabs) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [tabs.requests, tabs.suggestions, tabs.friendList]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Friends"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09019607843, green: 0.3568627451, blue: 0.6196078431, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backScreen))
    }
    @objc private func backScreen() {
        let mainViewController = MainRouter.createModule()
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}

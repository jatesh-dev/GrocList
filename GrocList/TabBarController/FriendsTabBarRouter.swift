//
//  FriendsTabBarRouter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 01/04/2021.
//

import UIKit

class FriendsTabBarRouter {
    
    var viewController: UIViewController
    typealias SubModulesFriendsTabs = (
        requests: UIViewController,
        suggestions: UIViewController,
        friendList: UIViewController
    )
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension FriendsTabBarRouter {
    
    static func createModule(usingSubModules subModules: SubModulesFriendsTabs) -> FriendsTabs {
        let requestTabBar = UITabBarItem(title: "Requests", image: #imageLiteral(resourceName: "friendRequest"), tag: 11)
        let suggestionTabBar = UITabBarItem(title: "Suggestions", image: #imageLiteral(resourceName: "friendSuggestions"), tag: 12)
        let friendListTabBar = UITabBarItem(title: "Friends", image: #imageLiteral(resourceName: "friends"), tag: 12)
        
        subModules.requests.tabBarItem = requestTabBar
        subModules.suggestions.tabBarItem = suggestionTabBar
        subModules.friendList.tabBarItem = friendListTabBar
        
        return(
            requests: subModules.requests,
            suggestions: subModules.suggestions,
            friendList: subModules.friendList
        )
    }
}

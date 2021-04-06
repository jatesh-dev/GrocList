//
//  FriendsTabBarModulesBuilder.swift
//  GrocList
//
//  Created by Jatesh Kumar on 01/04/2021.
//

import UIKit

class FriendsTabBarModuleBuilder {
    static func build(usingSubModules subModules: FriendsTabBarRouter.SubModulesFriendsTabs) -> UITabBarController {
        let tabs = FriendsTabBarRouter.createModule(usingSubModules: subModules)
        let tabBarController = FriendsTabBarController(tabs: tabs)
        return tabBarController
    }
}

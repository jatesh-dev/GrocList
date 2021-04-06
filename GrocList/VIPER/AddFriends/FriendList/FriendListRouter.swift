//
//  FriendListRouter.swift
//  GrocList
//
//  Created Jatesh Kumar on 05/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Hasnain Kanji
//

import UIKit

final class FriendListRouter {

    weak var viewController: UIViewController?

    deinit {
        print("deinit FriendListRouter")
    }

    static func createModule() -> UIViewController {

        // Change to get view from storyboard if not using progammatic UI
        
        let view = friendListStoryboard.instantiateViewController(identifier: "FriendListViewController") as? FriendListViewController
        let interactor = FriendListInteractor()
        let router = FriendListRouter()
        let presenter = FriendListPresenter(interface: view!, interactor: interactor, router: router)

        view!.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view!
    }
    static var friendListStoryboard: UIStoryboard {return UIStoryboard(name: "AddFriends", bundle: Bundle.main)}
}

extension FriendListRouter: FriendListWireframeProtocol {

}
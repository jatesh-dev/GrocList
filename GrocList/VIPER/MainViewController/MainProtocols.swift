//
//  MainProtocols.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

protocol MainWireframeProtocol: class {
    static func createModule () -> MainViewController
}

protocol MainPresenterProtocol: class {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorInputProtocol? { get set }
    var router: MainWireframeProtocol? { get set }
    func showUsers(currentUserID: String)
}

protocol MainInteractorInputProtocol: class {
    var presenter: MainInteractorOutputProtocol? { get set }
    func getUsers(roomID: String)
}

protocol MainInteractorOutputProtocol: class {
    func fetchedFriends(users: [User])
}

protocol MainViewProtocol: class {
    func updateView(users: [User])
}

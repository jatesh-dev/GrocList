//
//  GrocViewProtocols.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation

protocol GrocViewWireframeProtocol: class {
    static func createModule (grockKey: String?, secondUser: User?) -> GrocViewController
}

protocol GrocViewPresenterProtocol: class {
    var view: GrocViewViewProtocol? { get set }
    var interactor: GrocViewInteractorInputProtocol? { get set }
    var router: GrocViewWireframeProtocol? { get set }
    
    func getGrocList(grocKey: String)
    func deleteGroc(roomId: String, grocKey: String)
    func updateGrocStatus(roomId: String, status: String, grocKey: String)
    func updateGrocDescription(roomId: String, description: String, grocKey: String)
    func getAssigneeName(uid: String)
}

protocol GrocViewInteractorInputProtocol: class {
    var presenter: GrocViewInteractorOutputProtocol? { get set }
    
    func fetchDataFromDB(grocKey: String)
    func deleteGrocFromDB(roomId: String, grocKey: String)
    func updateGrocStatusIntoDB(roomId: String, status: String, grocKey: String)
    func updateGrocDescriptionIntoDB(roomId: String, description: String, grocKey: String)
    func getAssigneeNameFromDB(uid: String)
}

protocol GrocViewInteractorOutputProtocol: class {
    func setData(grocList: [Grocs])
    func setAssigneeName(name: String)
    func error()
}

protocol GrocViewViewProtocol: class {
    func showLoader()
    func hideLoader()
    func setupGrocView (grocList: [Grocs])
    func setAssigneeName(name: String)
    func error()
}

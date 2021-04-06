//
//  GrocViewPresenter.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class GrocViewPresenter: GrocViewPresenterProtocol {
    var view: GrocViewViewProtocol?
    var interactor: GrocViewInteractorInputProtocol?
    var router: GrocViewWireframeProtocol?
    
    func getGrocList(grocKey: String) {
        interactor?.fetchDataFromDB(grocKey: grocKey)
    }
    
    func deleteGroc(roomId: String, grocKey: String) {
        interactor?.deleteGrocFromDB(roomId: roomId, grocKey: grocKey)
    }
    
    func updateGrocStatus(roomId: String, status: String, grocKey: String) {
        interactor?.updateGrocStatusIntoDB(roomId: roomId, status: status, grocKey: grocKey)
    }
    
    func updateGrocDescription(roomId: String, description: String, grocKey: String) {
        interactor?.updateGrocDescriptionIntoDB(roomId: roomId, description: description, grocKey: grocKey)
    }
    
    func getAssigneeName(uid: String) {
        interactor?.getAssigneeNameFromDB(uid: uid)
    }
}

extension GrocViewPresenter: GrocViewInteractorOutputProtocol {
    func setAssigneeName(name: String) {
        view?.setAssigneeName(name: name)
    }
    
    func setData(grocList: [Grocs]) {
        view?.setupGrocView(grocList: grocList)
    }
    func error() {
        view?.error()
    }
}

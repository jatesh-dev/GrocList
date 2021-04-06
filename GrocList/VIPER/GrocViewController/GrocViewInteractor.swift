//
//  GrocViewInteractor.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation

class GrocViewInteractor: GrocViewInteractorInputProtocol {
    
    var presenter: GrocViewInteractorOutputProtocol?
    
    func fetchDataFromDB(grocKey: String) {
        eventDbChildAdded(grocKey)
        eventDbUpdate(grocKey)
        eventDbChildRemoved(grocKey)
        
    }
    
    func deleteGrocFromDB(roomId: String, grocKey: String) {
        let result = GrocDbManager.shared.deleteGroc(roomId: roomId, grocKey: grocKey)
        if result {
            fetchDataFromDB(grocKey: grocKey)
        } else {
            presenter?.error()
        }
    }
    
    func updateGrocStatusIntoDB(roomId: String, status: String, grocKey: String) {
        let result = GrocDbManager.shared.updateGrocStatus(roomId: roomId, status: status, grocKey: grocKey)
        if result {
            fetchDataFromDB(grocKey: grocKey)
        } else {
            presenter?.error()
        }
    }
    
    func updateGrocDescriptionIntoDB(roomId: String, description: String, grocKey: String) {
        let result = GrocDbManager.shared.updateGrocDesc(roomId: roomId, description: description, grocKey: grocKey)
        if result {
            fetchDataFromDB(grocKey: grocKey)
        } else {
            presenter?.error()
        }
    }
    
    func getAssigneeNameFromDB(uid: String) {
        GrocDbManager.shared.getAssigneeName(uid: uid) { (status) in
            switch status {
            case .success(let name):
                self.presenter?.setAssigneeName(name: name)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    fileprivate func eventDbUpdate(_ grocKey: String) {
        GrocDbManager.shared.grocItemChanged(eventType: .childChanged, grocKey: grocKey) {(data) in
            switch data {
            case .success(let data):
                self.presenter?.setData(grocList: data)
            case .failure(let error):
                print("Error: ", error)
                self.presenter?.error()
            }
        }
    }
    
    fileprivate func eventDbChildAdded(_ grocKey: String) {
        GrocDbManager.shared.grocItemChanged(eventType: .childAdded, grocKey: grocKey) {(data) in
            switch data {
            case .success(let data):
                self.presenter?.setData(grocList: data)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    fileprivate func eventDbChildRemoved(_ grocKey: String) {
        GrocDbManager.shared.grocItemChanged(eventType: .childRemoved, grocKey: grocKey) {(data) in
            switch data {
            case .success(let data):
                self.presenter?.setData(grocList: data)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

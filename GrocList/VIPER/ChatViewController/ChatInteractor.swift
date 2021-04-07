//
//  ChatInteractor.swift
//  GrocList
//
//  Created Jatesh Kumar on 06/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ChatInteractor {

    var msg = [Messages]()
    weak var presenter: ChatInteractorOutputProtocol?
    deinit {
        print("deinit ChatInteractor")
    }
}

extension ChatInteractor: ChatInteractorInputProtocol {
    func sendMessageIntoDB(chatKey: String, message: [String: String]) {
        DbManager.shared.sendMessage(chatKey: chatKey, values: message)
        fetchMessagesFromDB(chatRoomID: chatKey)
    }
    
    func fetchMessagesFromDB(chatRoomID: String) {
        eventDBChildChanged(chatKey: chatRoomID)
        eventDBChildAdded(chatKey: chatRoomID)
    }
    
    fileprivate func eventDBChildAdded(chatKey: String) {
        DbManager.shared.observer(event: .childAdded, chatKey: chatKey) { (data) in
            switch data {
            case .success(let data):
                self.msg = [Messages]()
                data.forEach({ (data) in
                    self.msg.append(data)
                })
                self.presenter?.fetchedMessages(messages: self.msg)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
    fileprivate func eventDBChildChanged(chatKey: String) {
        DbManager.shared.observer(event: .childChanged, chatKey: chatKey) { (data) in
            switch data {
            case .success(let data):
                self.msg = [Messages]()
                data.forEach({ (data) in
                    self.msg.append(data)
                })
                self.presenter?.fetchedMessages(messages: self.msg)
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

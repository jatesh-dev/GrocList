//
//  ChatPresenter.swift
//  GrocList
//
//  Created Jatesh Kumar on 06/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ChatPresenter {

    weak private var view: ChatViewProtocol?
    var interactor: ChatInteractorInputProtocol?
    private let router: ChatWireframeProtocol

    init(interface: ChatViewProtocol, interactor: ChatInteractorInputProtocol?, router: ChatWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    deinit {
        print("deinit ChatPresenter")
    }

    func viewDidLoad() {

    }
}

extension ChatPresenter: ChatPresenterProtocol {
    func sendMessage(chatKey: String, message: [String: String]) {
        interactor?.sendMessageIntoDB(chatKey: chatKey, message: message)
    }
    
    func getMessages(chatRoomID: String) {
        interactor?.fetchMessagesFromDB(chatRoomID: chatRoomID)
    }
}

extension ChatPresenter: ChatInteractorOutputProtocol {
    func fetchedMessages(messages: [Messages]) {
        view?.displayChat(chat: messages)
    }
}

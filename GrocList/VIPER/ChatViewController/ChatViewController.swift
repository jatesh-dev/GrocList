//
//  ChatViewController.swift
//  GrocList
//
//  Created Jatesh Kumar on 06/04/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

	var presenter: ChatPresenterProtocol?

    deinit {
        print("deinit ChatViewController")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        networkRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ChatViewController {
}

extension ChatViewController: ChatViewProtocol {

     func showLoader() {
        DispatchQueue.main.async {
            self.showLoadingIndicator(withDimView: true)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
        }
    }

    func setupEnglishView() {

    }
    
    func setupArabicView() {

    }
}

extension ChatViewController: SetupViewController {
    
    func setupNavigation() {
    }
    
    func setupView() {
    }
    
    func networkRequest() {
    }
}

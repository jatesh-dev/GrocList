//
//  SignupInteractor.swift
//  GrocList
//
//  Created by Jatesh Kumar on 30/03/2021.
//

import Foundation
import UIKit

class SignupInteractor: SignupPresenterToInteractor {
    var presenter: SignupInteractorToPresenter?
    func createUser(email: String, password: String, name: String, imageUrl: URL) {
        
        GrocDbManager.shared.createUser(email: email, password: password, name: name, imageUrl: imageUrl) { (result) in
            switch result {
            case .success:
                self.presenter?.userCreateStatus(status: true)
                
            case .failure:
                self.presenter?.userCreateStatus(status: false)
            }
        }
    }
}

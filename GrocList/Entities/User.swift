//
//  User.swift
//  GrocList
//
//  Created by Syed Asad on 23/02/2021.
//
import UIKit
import Foundation

class User: Codable {
    
	var userID: String?
	var name: String?
	var email: String?
    var profileURL: URL?
    
    init(userID: String?) {
		self.userID = userID
	}
	
    init(name: String?, userID: String?) {
		self.name = name
		self.userID = userID
	}
	
    init(data: [String: Any]?) {
		self.userID = data?["id"] as? String
		self.name = data?["name"] as? String
		self.email = data?["email"] as? String
	}
}

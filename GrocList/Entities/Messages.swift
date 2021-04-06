//
//  Messages.swift
//  GrocList
//
//  Created by Syed Asad on 26/02/2021.
//

import UIKit

class Messages: Codable {
	
	var fromID: String?
	var msg: String?
	var time: String?
	
	init(fromID: String, msg: String?, time: String?) {
		self.fromID = fromID
		self.msg = msg
		self.time = time
	}
	
	init(data: [String: Any]?) {
		self.fromID = data?["fromID"] as? String
		self.msg = data?["msg"] as? String
		self.time = data?["time"] as? String
	}
}

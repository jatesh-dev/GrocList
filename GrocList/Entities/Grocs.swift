//
//  Groc.swift
//  GrocList
//
//  Created by Jatesh Kumar on 23/02/2021.
//

import Foundation

struct Grocs: Codable {
    
    var grocName: String?
    var grocDescription: String?
    var grocAssigneeID: String?
    var status: String?
    var roomID: String?
    var timestamp: String?
    var seenStatus: String?
    
    init(grocName: String?, grocDescription: String?, grocAssigneeID: String?, status: String?) {
        self.grocName = grocName
        self.grocDescription = grocDescription
        self.grocAssigneeID = grocAssigneeID
        self.status = status
    }
    
    init(data: [String: AnyObject]?) {
        self.grocName = data?["name"] as? String
        self.grocDescription = data?["description"] as? String
        self.grocAssigneeID = data?["assigneeID"] as? String
        self.status = data?["status"] as? String
        self.roomID = data?["id"] as? String
        self.timestamp = data?["timestamp"] as? String
        self.seenStatus = data?["seenStatus"] as? String
    }
}

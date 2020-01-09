//
//  Update.swift
//  VK
//
//  Created by Marat Mikaelyan on 30/12/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import Foundation
import RealmSwift

class Update: Object {
    static let interval = 10.0
    @objc dynamic var dataType: String = ""
    @objc dynamic var timeStamp: Double = 0.0
    
    convenience init(dataType: String, timeStamp: Double) {
        self.init()
        
        self.dataType = dataType
        self.timeStamp = timeStamp
    }
    
    override static func primaryKey() -> String? {
        return "dataType"
    }
}

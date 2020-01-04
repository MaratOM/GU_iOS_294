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
    @objc dynamic var dataType: String = ""
    @objc dynamic var timeStamp: Date = Date.distantPast
    
    convenience init(dataType: String, timeStamp: Date) {
        self.init()
        
        self.dataType = dataType
        self.timeStamp = timeStamp
    }
}

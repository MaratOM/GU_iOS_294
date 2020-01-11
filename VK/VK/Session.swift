//
//  Session.swift
//  Weather
//
//  Created by Andrey Antropov on 01/12/2019.
//  Copyright © 2019 Morizo. All rights reserved.
//

import Foundation

class Session {
    private init() { }
    
    var accessToken = ""
    
    static let shared = Session()
}

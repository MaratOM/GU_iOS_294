//
//  NetworkService.swift
//  Weather
//
//  Created by Andrey Antropov on 01/12/2019.
//  Copyright © 2019 Morizo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
        return session
    }()
    
    public func loadGroups(complition: @escaping (Result<[Group], Error>) -> Void) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
                switch response.result {
                case let .success(data):
                    let json = JSON(data)
                    let groupsJSON = json["response"]["items"].arrayValue
                    let groups = groupsJSON.map{ Group(from: $0)}
                    complition(.success(groups))
                case let .failure(error):
                    complition(.failure(error))
            }
        }
    }
}

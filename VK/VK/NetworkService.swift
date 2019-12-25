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
    
    private enum dataModel {
        case groups
        case friends
    }
    
    private let baseUrl = "https://api.vk.com"
    private let APIversion = "5.92"
    private let accessToken = Session.shared.accessToken


    public func loadGroups(complition: @escaping (Result<[Any], Error>) -> Void) {
        let path = "/method/groups.get"
        
        self.loadData(model: .groups, path: path, methodParams: [:], complition: complition)
    }
    
    public func loadFriends(complition: @escaping (Result<[Any], Error>) -> Void) {
        let path = "/method/friends.get"
        let params: Parameters = [
            "fields": "photo_100",
        ]
        
        self.loadData(model: .friends, path: path, methodParams: params, complition: complition)
    }
    
    private func loadData(model: dataModel, path: String, methodParams: Parameters, complition: @escaping (Result<[Any], Error>) -> Void) {
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
                
        params.merge(methodParams) { (_, new) in new }
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
                switch response.result {
                case let .success(data):
                    let listJSON = JSON(data)["response"]["items"].arrayValue
                    var list: Array<Any>
                    switch model {
                    case .groups:
                        list = listJSON.map{ Group(from: $0)}
                    case .friends:
                        list = listJSON.map{ Friend(from: $0)}
                    }
                    complition(.success(list))
                case let .failure(error):
                    complition(.failure(error))
            }
        }
    }
}

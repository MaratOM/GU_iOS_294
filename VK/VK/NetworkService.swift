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
import RealmSwift

class NetworkService {
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
//        print(Session.shared.accessToken)
        return session
    }()
    
    private enum dataModel {
        case group
        case friend
        case photo
        case news
    }
    
    private let baseUrl = "https://api.vk.com"
    private let APIversion = "5.92"
    private let accessToken = Session.shared.accessToken
    
    public func searchGroups(q: String, complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/groups.search"
        let params: Parameters = [
            "q": q,
        ]
        
        self.loadDataRequest(model: .group, path: path, methodParams: params, complition: complition)
    }
    
    public func loadFriends(complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/friends.get"
        let params: Parameters = [
            "fields": "photo_100",
        ]
        
        self.loadDataRequest(model: .friend, path: path, methodParams: params, complition: complition)
    }
    
    private func loadDataRequest(model: dataModel, path: String, methodParams: Parameters, complition: @escaping (Result<[Object], Error>) -> Void) {
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
                    var list = Array<Object>()
                    switch model {
                    case .group:
                        list = listJSON.map { Group(from: $0) }
                    case .friend:
                        listJSON.forEach {
                            guard let friend = Friend(from: $0) else { return }
                            list.append(friend)
                        }
                    case .photo:
                        list = listJSON.map { Photo(ownerId:params["owner_id"] as! Int,from: $0) }
                    case .news:
                        listJSON.forEach {
                            guard let news = News(from: $0) else { return }
                            list.append(news)
                        }
                    }
                    complition(.success(list))
                case let .failure(error):
                    complition(.failure(error))
            }
        }
    }
    
    private func loadDataFactory<T: Object>(type: T.Type, additionalData: Dictionary<String, Any>, complition: @escaping (Result<[Object], Error>) -> Void) {
        var path = ""
        var methodParams: Parameters = [:]
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
        
        switch T() {
        case is Group:
            path = "/method/groups.get"
        case is Friend:
            path = "/method/friends.get"
            methodParams = [
                "fields": "photo_100",
            ]
        case is Photo:
            guard let ownerId = additionalData["ownerId"] else { return }
            path = "/method/photos.getAll"
            methodParams = [
                "owner_id": ownerId,
            ]
        case is News:
            path = "/method/wall.get"
            methodParams = [
                "filters": "post",
            ]
        default:
            return
        }

        params.merge(methodParams) { (_, new) in new }
                
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
                switch response.result {
                case let .success(data):
                    let listJSON = JSON(data)["response"]["items"].arrayValue
                    var list = Array<Object>()
                    switch T() {
                    case is Group:
                        list = listJSON.map { Group(from: $0) }
                    case is Friend:
                        listJSON.forEach {
                            guard let friend = Friend(from: $0) else { return }
                            list.append(friend)
                        }
                    case is Photo:
                        guard let ownerId = additionalData["ownerId"] else { return }
                        list = listJSON.map { Photo(ownerId: ownerId as! Int, from: $0) }
                    case is News:
                        listJSON.forEach {
                            guard let news = News(from: $0) else { return }
                            list.append(news)
                        }
                    default:
                        return
                    }
                    complition(.success(list))
                case let .failure(error):
                    complition(.failure(error))
            }
        }
    }
    
    public func loadDataWithRealm<T: Object>(type: T.Type, additionalData: Dictionary<String, Any> = [:]) {
        let realmService = RealmService.shared
        let networkService = NetworkService()
        var items: Results<T>
        
        if let ownerId = additionalData["ownerId"] {
            items = try! realmService.get(type).filter("ownerId = %i", ownerId)
        } else {
            items = try! realmService.get(type)
        }
        
        let updatedTime = try! realmService.get(Update.self).filter("dataType == %@", type.className()).first?.timeStamp ?? NSDate().timeIntervalSince1970
                
        if (items.count == 0 || NSDate().timeIntervalSince1970 - Double(updatedTime) > Update.interval) {
            networkService.loadDataFactory(type: type, additionalData: additionalData) { result in
                switch result {
                case let .success(items):
                    print("\(type.className()) items got from api")

                    try! realmService.save(items)
                    
                    let updateTime = Update(dataType: type.className(), timeStamp: NSDate().timeIntervalSince1970)
                    try! realmService.save([updateTime])
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    public func addLike(type: String, ownerId: Int, id: Int) {
        let path = "/method/likes.add"

        self.likesActionHandle(path: path, type: type, ownerId: ownerId, id: id)
    }
    
    public func deleteLike(type: String, ownerId: Int, id: Int) {
        let path = "/method/likes.delete"

        self.likesActionHandle(path: path, type: type, ownerId: ownerId, id: id)
    }
    
    private func likesActionHandle(path: String, type: String, ownerId: Int, id: Int) {
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
        let methodParams: Parameters = [
            "type": type,
            "owner_id": String(ownerId),
            "item_id": String(id)
        ]
        params.merge(methodParams) { (_, new) in new }
                    
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { _ in }
    }
    
    public func joinGroup(id: Int) {
        let path = "/method/groups.join"

        self.groupsActionHandle(path: path, id: id)
    }
    
    public func leaveGroup(id: Int) {
        let path = "/method/groups.leave"

        self.groupsActionHandle(path: path, id: id)
    }
    
    private func groupsActionHandle(path: String, id: Int) {
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
        let methodParams: Parameters = [
            "group_id": String(id)
        ]
        params.merge(methodParams) { (_, new) in new }
                    
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { _ in }
    }
}

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
    
    public func loadPhotos(ownerId: Int, complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "owner_id": ownerId,
        ]
        
        self.loadDataRequest(model: .photo, path: path, methodParams: params, complition: complition)
    }
    
    private func loadDataRequest(model: dataModel, path: String, methodParams: Parameters, complition: @escaping (Result<[Object], Error>) -> Void) {
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
        params.merge(methodParams) { (_, new) in new }
        
        print(accessToken)
        
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
                            if($0["first_name"].stringValue != "DELETED") {
                                list.append(Friend(from: $0))
                            }
                        }
                    case .photo:
                        list = listJSON.map { Photo(ownerId:params["owner_id"] as! Int,from: $0) }
                    case .news:
                        listJSON.forEach {
                            if($0["attachments"].arrayValue.filter{ $0["type"] == "photo" }.count > 0) {
                                list.append(News(from: $0))
                            }
                        }
                    }
                    complition(.success(list))
                case let .failure(error):
                    complition(.failure(error))
            }
        }
    }
    
    private func loadDataFactory<T: Object>(type: T.Type, complition: @escaping (Result<[Object], Error>) -> Void) {
        var path = ""
        var methodParams: Parameters = [:]
        var params: Parameters = [
            "access_token": accessToken,
            "extended": 1,
            "v": APIversion
        ]
        
        switch type.className() {
        case Group.className():
            path = "/method/groups.get"
        case Friend.className():
            path = "/method/friends.get"
            methodParams = [
                "fields": "photo_100",
            ]
//        case Photo.className():
//            path = "/method/photos.getAll"
//            methodParams = [
//                "owner_id": ownerId,
//            ]
        case News.className():
            path = "/method/wall.get"
            methodParams = [
                "filters": "post",
            ]
        default:
            return
        }

        params.merge(methodParams) { (_, new) in new }
        
        print(accessToken)
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
                switch response.result {
                case let .success(data):
                    let listJSON = JSON(data)["response"]["items"].arrayValue
                    var list = Array<Object>()
                    switch type.className() {
                    case Group.className():
                        list = listJSON.map { Group(from: $0) }
                    case Friend.className():
                        listJSON.forEach {
                            if($0["first_name"].stringValue != "DELETED") {
                                list.append(Friend(from: $0))
                            }
                        }
                    case Photo.className():
                        list = listJSON.map { Photo(ownerId:params["owner_id"] as! Int,from: $0) }
                    case News.className():
                        listJSON.forEach {
                            if($0["attachments"].arrayValue.filter{ $0["type"] == "photo" }.count > 0) {
                                list.append(News(from: $0))
                            }
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
    
    public func loadDataWithRealm<T: Object>(type: T.Type, additionalData: Dictionary<String, String> = [:]) {
        let realmService = RealmService()
        let networkService = NetworkService()
        let items = try! realmService.get(type)
        let updatedTime = try! realmService.get(Update.self).filter("dataType == %@", type.className()).first?.timeStamp ?? NSDate().timeIntervalSince1970
                
        if (items.count == 0 || NSDate().timeIntervalSince1970 - Double(updatedTime) > Update.interval) {
            networkService.loadDataFactory(type: type) { result in
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

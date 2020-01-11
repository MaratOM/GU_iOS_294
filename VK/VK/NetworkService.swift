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


    public func loadGroups(complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/groups.get"
        
        self.loadData(model: .group, path: path, methodParams: [:], complition: complition)
    }
    
    public func searchGroups(q: String, complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/groups.search"
        let params: Parameters = [
            "q": q,
        ]
        
        self.loadData(model: .group, path: path, methodParams: params, complition: complition)
    }
    
    public func loadFriends(complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/friends.get"
        let params: Parameters = [
            "fields": "photo_100",
        ]
        
        self.loadData(model: .friend, path: path, methodParams: params, complition: complition)
    }
    
    public func loadPhotos(ownerId: Int, complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "owner_id": ownerId,
        ]
        
        self.loadData(model: .photo, path: path, methodParams: params, complition: complition)
    }
    
    public func loadNews(complition: @escaping (Result<[Object], Error>) -> Void) {
        let path = "/method/wall.get"
        let params: Parameters = [
            "filters": "post",
        ]
        
        self.loadData(model: .news, path: path, methodParams: params, complition: complition)
    }
    
    private func loadData(model: dataModel, path: String, methodParams: Parameters, complition: @escaping (Result<[Object], Error>) -> Void) {
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
    
    public func addLike(type: String, ownerId: Int, id: Int) {
        let path = "/method/likes.add"

        self.likeActionHandle(path: path, type: type, ownerId: ownerId, id: id)
    }
    
    public func deleteLike(type: String, ownerId: Int, id: Int) {
        let path = "/method/likes.delete"

        self.likeActionHandle(path: path, type: type, ownerId: ownerId, id: id)
    }
    
    private func likeActionHandle(path: String, type: String, ownerId: Int, id: Int) {
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

}

//
//  Constants.swift
//  runnerpia
//
//  Created by 박경준 on 2023/06/13.
//

import Foundation
//HTTP : http://pien.kr:4500
//HTTPS: https://server.pien.kr:4500
struct K {
    struct ProductionServer {
        static let baseURL = "https://server.pien.kr:4500"
    }
    
    struct APIParameterKey {
        // MARK: 유저 모델 관련 API 파라미터 키값 리스트
        // Route 모델 파라미터 키와 중복될 수 있음
        static let name = "name"
        static let nickname = "nickname"
        static let userId = "userId"
        static let password = "password"
        static let birthDate = "birthDate"
        static let gender = "gender"
        static let city = "city" // MARK: 추후 삭제가능
        static let state = "state" // MARK: 추후 삭제가능
        static let recommendedTags = "recommendedTags"
        static let secureTags = "secureTags"
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        
        // MARK: Route 모델 관련 API 파라미터 키값 리스트
        static let arrayOfPos = "arrayOfPos"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let routeName = "routeName"
        static let runningTime = "runningTime"
        static let review = "review"
        static let runningDate = "runningDate"
        static let distance = "distance"
//        static let routeImage = "routeImage"
        static let files = "files"
        static let location = "location"
        static let mainRoute = "mainRoute"
        static let id = "id"
        static let user = "user"
        static let startPoint = "startPoint"
        static let subRoute = "subRoute"
        static let check = "check"
        static let result = "result"
        static let count = "count"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case multipartFormdata = "multipart/form-data"
}

enum ContentType: String {
    case json = "application/json"
}

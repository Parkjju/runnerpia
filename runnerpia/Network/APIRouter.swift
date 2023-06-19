//
//  APIRouter.swift
//  runnerpia
//
//  Created by 박경준 on 2023/06/13.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

// MARK: UserEndpoint
enum UserEndPoint: APIConfiguration{
    
    // MARK: 유저 관련 메서드
    case kakaoLogin
    case logout(accessToken: String)
    case checkDuplicateID(id: String)
    case checkDuplicateNickname(nickname: String)
    
    // MARK: 북마크 관련 메서드
    case getAllBookmark(accessToken: String)
    case createBookmark(accessToken: String)
    case deleteBookmark(accessToken: String, bookmarkId: Int)
    
    // MARK: 추천경로 관련 메서드
    case getNumberOfUsingRecommendedRoute(accessToken: String)
    case increaseNumberOfUsingRecommendedRoute(accessToken: String)
    
    
    var method: HTTPMethod{
        switch self{
        case .kakaoLogin:
            return .post
        case .logout:
            return .get
        case .checkDuplicateID:
            return .get
        case .checkDuplicateNickname:
            return .get
        case .getAllBookmark:
            return .get
        case .createBookmark:
            return .post
        case .deleteBookmark:
            return .post
        case .getNumberOfUsingRecommendedRoute:
            return .get
        case .increaseNumberOfUsingRecommendedRoute:
            return .get
        }
    }
    
    var path: String{
        switch self{
        case .kakaoLogin:
            return "/auth/kakao"
        case .logout:
            return "/auth/logout"
        case .checkDuplicateID(let id):
            return "/user/checkId/\(id)"
        case .checkDuplicateNickname(let nickname):
            return "/user/checkNickname/\(nickname)"
        case .getAllBookmark:
            return "/user/bookmark/getAll"
        case .createBookmark:
            return "/user/bookmark/create"
        case .deleteBookmark:
            return "/user/bookmark/delete"
        case .getNumberOfUsingRecommendedRoute:
            return "/user/getUseRecommended"
        case .increaseNumberOfUsingRecommendedRoute:
            return "/user/increaseUseRecommended"
        }
    }
    
    var parameters: Alamofire.Parameters?{
        switch self{
        case .kakaoLogin:
            return nil
        case .logout(let accessToken):
            return [K.APIParameterKey.accessToken: accessToken]
        case .checkDuplicateID(let id):
            return [K.APIParameterKey.id: id]
        case .checkDuplicateNickname(let nickname):
            return [K.APIParameterKey.nickname: nickname]
        case .getAllBookmark(let accessToken):
            return [K.APIParameterKey.accessToken: accessToken]
        case .createBookmark(let accessToken):
            return [K.APIParameterKey.accessToken: accessToken]
        case .deleteBookmark(let accessToken, let id):
            return [K.APIParameterKey.accessToken: accessToken, K.APIParameterKey.id: id]
        case .getNumberOfUsingRecommendedRoute(let accessToken):
            return [K.APIParameterKey.accessToken: accessToken]
        case .increaseNumberOfUsingRecommendedRoute(let accessToken):
            return [K.APIParameterKey.accessToken: accessToken]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
 
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
    
}

// MARK: RouteEndpoint
enum RouteEndPoint: APIConfiguration{
    case postRoute(accessToken: String, route: Route)
    case getRoute(accessToken: String, id: Int)
    case getReview(accessToken: String, id: Int)
    case modifyRoute(accessToken: String, id: Int)
    case deleteRoute(accessToken: String, id: Int)
    case checkIsRun(accessToken: String, id: Int)
    case getAllRoute(accessToken: String)
    case getAllReview(accessToken: String)
    case getRouteFromCoordinate(accessToken: String, longitude: CGFloat, latitude: CGFloat)
    case getRouteFromCityName(accessToken: String, city: String, state: String)
    case checkRouteNameIsDuplicated(accessToken: String, routeName: String)
    case getRecommendedRouteFromCoordinate(accessToken: String, longitude: CGFloat, latitude: CGFloat)
    case getPopularTags(accessToken: String)
    
    var method: Alamofire.HTTPMethod{
        switch self{
        case .postRoute:
            return .post
        case .getRoute:
            return .get
        case .getReview:
            return .get
        case .modifyRoute:
            return .put
        case .deleteRoute:
            return .delete
        case .checkIsRun:
            return .get
        case .getAllRoute:
            return .get
        case .getAllReview:
            return .get
        case .getRouteFromCoordinate:
            return .get
        case .getRouteFromCityName:
            return .get
        case .checkRouteNameIsDuplicated:
            return .get
        case .getRecommendedRouteFromCoordinate:
            return .get
        case .getPopularTags:
            return .get
        }
    }
    
    var path: String{
        switch self{
        case .postRoute:
            return "/running-route"
        case .getRoute(let accessToken, let id):
            return "/running-route/main/\(id)"
        case .getReview(let accessToken, let id):
            return "/running-route/sub/\(id)"
        case .modifyRoute(let accessToken, let id):
            return "/running-route/\(id)"
        case .deleteRoute(let accessToken, let id):
            return "/running-route/\(id)"
        case .checkIsRun(let accessToken, let id):
            return "/running-route/checkRunningExperience/\(id)"
        case .getAllRoute:
            return "/running-route/allMainRoute"
        case .getAllReview:
            return "/running-route/allSubRoute"
        case .getRouteFromCoordinate(let accessToken, let longitude, let latitude):
            return "/running-route/searchLocation?latitude=\(latitude)&longitude=\(longitude)"
        case .getRouteFromCityName:
            return .get
        case .checkRouteNameIsDuplicated:
            return .get
        case .getRecommendedRouteFromCoordinate:
            return .get
        case .getPopularTags:
            return .get
        }
    }
    
    var parameters: Alamofire.Parameters?
    
    func asURLRequest() throws -> URLRequest {
        <#code#>
    }
    
    
}

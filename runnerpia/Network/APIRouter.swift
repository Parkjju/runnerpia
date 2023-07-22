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
    
    // MARK: 액세스토큰은 파라미터에 명시적으로 담아 보내지 않음! - 수정 추후 필요
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
    case modifyRoute(accessToken: String, modifiedRoute: Route, id: Int)
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
        case .getRoute(_, let id):
            return "/running-route/main/\(id)"
        case .getReview(_, let id):
            return "/running-route/sub/\(id)"
        case .modifyRoute(_, _, let id):
            return "/running-route/\(id)"
        case .deleteRoute(_, let id):
            return "/running-route/\(id)"
        case .checkIsRun(_, let id):
            return "/running-route/checkRunningExperience/\(id)"
        case .getAllRoute:
            return "/running-route/allMainRoute"
        case .getAllReview:
            return "/running-route/allSubRoute"
        case .getRouteFromCoordinate(_, let longitude, let latitude):
            return "/running-route/searchLocation?latitude=\(latitude)&longitude=\(longitude)"
        case .getRouteFromCityName(_, let city, let state):
            return "/running-route/searchCity?city=\(city)&state=\(state)"
        case .checkRouteNameIsDuplicated(_, let routeName):
            return "/running-route/checkRouteName?routeName=\(routeName)"
        case .getRecommendedRouteFromCoordinate(_, let longitude, let latitude):
            return "/running-route/recommendedRoute?latitude=\(latitude)&longitude=\(longitude)"
        case .getPopularTags:
            return "/running-route/popularTags"
        }
    }
    
    // MARK: URL 파라미터도 parameters에 필요한가? - 직접 써보고 수정해보기
    // MARK: 일단은 제외
    var parameters: Alamofire.Parameters? {
        switch self{
        case .postRoute(_, let route):
            return [
                K.APIParameterKey.arrayOfPos: route.arrayOfPos!.map({ coord in
                    return [
                        "latitude": coord.latitude,
                        "longitude": coord.longitude
                    ]
                }),
                K.APIParameterKey.routeName: route.routeName! ,
                K.APIParameterKey.runningTime: route.runningTime! ,
                K.APIParameterKey.review: route.review!,
                K.APIParameterKey.runningDate: route.runningDate! ,
                K.APIParameterKey.distance: String(route.distance!),
                K.APIParameterKey.files: route.files!,
                K.APIParameterKey.location: route.location!,
                K.APIParameterKey.recommendedTags: route.recommendedTags!,
                K.APIParameterKey.secureTags: route.secureTags!,
                K.APIParameterKey.mainRoute: route.mainRoute!
            ]
        case .getRoute:
            return nil
        case .getReview:
            return [:]
        // MARK: 수정 대상 데이터만 선택해서 저장 - Loopable 프로토콜 채택
        // MARK: try - catch 잘 이루어지는지 확인 필요
        case .modifyRoute(_, let modifiedRoute, _):
            guard let props = try? modifiedRoute.allProperties() else {return nil}
            return props
        case .deleteRoute:
            return [:]
        case .checkIsRun:
            return [:]
        case .getAllRoute:
            return [:]
        case .getAllReview:
            return [:]
        case .getRouteFromCoordinate(_,let longitude, let latitude):
            return [
                K.APIParameterKey.longitude: longitude,
                K.APIParameterKey.latitude: latitude
            ]
        case .getRouteFromCityName(_, let city, let state):
            return [
                K.APIParameterKey.city: city,
                K.APIParameterKey.state: state
            ]

        case .checkRouteNameIsDuplicated(_, let routeName):
            return [
                K.APIParameterKey.routeName: routeName
            ]
        case .getRecommendedRouteFromCoordinate(_ , let longitude, let  latitude):
            return [
                K.APIParameterKey.longitude: longitude,
                K.APIParameterKey.latitude: latitude
            ]
        case .getPopularTags:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        print(url)
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
 
        // Parameters
        if let parameters = parameters {
            do {
                print(parameters)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            } 
        }
        
        return urlRequest
    }
    
    
}

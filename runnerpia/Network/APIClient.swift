//
//  APIClient.swift
//  runnerpia
//
//  Created by Jun on 2023/06/21.
//

import Foundation
import Alamofire

class APIClient {
    @discardableResult
    
    private static func performRequest<T:Decodable>(route:RouteEndPoint, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response) in
                            completion(response.result)
        }
    }

    static func getRoute(routeId: Int, completion: @escaping (Result<RouteData, AFError>) -> Void) {
        performRequest(route: .getRoute(accessToken: "", id: routeId), completion: completion)
    }



    static func postRoute(routeData: Route, completion: @escaping (Result<RouteId, AFError>) -> Void){
        performRequest(route: .postRoute(accessToken: "", route: routeData), completion: completion)
    }
    
    static func getRoute(routeId: Int, completion: @escaping (Result<MainRoute, AFError>) -> Void){
        performRequest(route: .getRoute(accessToken: "", id: routeId), completion: completion)
    }
    
    static func retryAPIRequest(routeData: Route, retryEndPoint: RouteEndPoint, completion: @escaping (Result<NetworkError, AFError>) -> Void){
        performRequest(route: retryEndPoint, completion: completion)
    }
    
    // 임시 - 에러타입 통일 후 삭제예정
    static func retryAPIRequestWithEntitiyError(routeData: Route, retryEndPoint: RouteEndPoint, completion: @escaping (Result<NetworkErrorWithEntitiyLarge, AFError>) -> Void){
        performRequest(route: retryEndPoint, completion: completion)
    }
}

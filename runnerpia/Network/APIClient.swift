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
    
    static func postRoute(routeData: RouteForServer, completion: @escaping (Result<RouteId, AFError>) -> Void){
        performRequest(route: .postRoute(accessToken: "", route: routeData), completion: completion)
    }
}

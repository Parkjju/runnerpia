//
//  Route.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import Foundation
import CoreLocation
import UIKit

// MARK: 커스텀타입을 전달하려면 해당 타입도 Codable을 채택해야함.
// MARK: CLLocationCoordinate2D에 대한 새로운 타입 정의 필요

struct Route: Loopable{
    let user: User?
    let routeName: String?
    let distance: Double?
    let arrayOfPos: [CLLocationCoordinate2D]?
    let location: String?
    let runningTime: String?
    let review: String?
    let runningDate: String?
    let recommendedTags: [String]?
    let secureTags: [String]?
    var files: [UIImage]?
}


// MARK: Codable용 타입과 별개로 UI에서 사용될 타입을 정의해야되나?
struct Coordinate: Codable{
    // MARK: 커스텀 인스턴스를 직렬화
    // MARK: Codable을 해치지는 않지만 Serialize가 되는지
    let latitude: String
    let longitude: String
}

struct RouteId: Codable{
    let routeId: Int
    
    enum CodingKeys: String, CodingKey{
        case routeId = "routeId"
    }
}

struct RouteForServer: Codable{
    let arrayOfPos: [Coordinate]
    let routeName: String
    let runningTime: String
    let review: String
    let runningDate: String
    let distance: String
    let files: [String]
    let location: String
    let recommendedTags: [String]
    let secureTags: [String]
    
    enum CodingKeys: String, CodingKey{
        case arrayOfPos = "arrayOfPos"
        case routeName = "routeName"
        case runningTime = "runningTime"
        case review = "review"
        case runningDate = "runningDate"
        case distance = "distance"
        case files = "files"
        case location = "location"
        case recommendedTags = "recommendedTags"
        case secureTags = "secureTags"
    }
}

struct Image: Codable{
    public let photo: String
    
    public init(photo: UIImage){
        guard let imageData = photo.pngData() else {
            self.photo = ""
            return
        }
        self.photo = imageData.base64EncodedString(options: .lineLength64Characters)
    }
}

extension Image{
    enum CodingKeys: String, CodingKey{
        case photo
    }
}

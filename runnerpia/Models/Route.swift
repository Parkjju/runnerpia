//
//  Route.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import Foundation
import CoreLocation
import UIKit

struct RouteData: Codable {
    let id: Int?
    let arrayOfPos: [CLLocationCoordinate2D]?
    let routeName: String?
    let runningDate: String?
    let location: String?
    let distance: Double?
    let runningTime: String?
    let recommendedTags: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case arrayOfPos
        case routeName
        case runningDate
        case location
        case distance
        case runningTime
        case recommendedTags
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) 
        arrayOfPos = try values.decodeIfPresent([CLLocationCoordinate2D].self, forKey: .arrayOfPos)
        routeName = try values.decodeIfPresent(String.self, forKey: .routeName)
        runningDate = try values.decodeIfPresent(String.self, forKey: .runningDate)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        runningTime = try values.decodeIfPresent(String.self, forKey: .runningTime)
        recommendedTags = try values.decodeIfPresent([String].self, forKey: .recommendedTags)
    }

}


// MARK: 커스텀타입을 전달하려면 해당 타입도 Codable을 채택해야함.
// MARK: CLLocationCoordinate2D에 대한 새로운 타입 정의 필요

struct Route: Loopable, Codable{
    let arrayOfPos: [CLLocationCoordinate2D]?
    let routeName: String?
    let runningTime: String?
    let review: String?
    let runningDate: String?
    let distance: Double?
    let files: [String]?
    let location: String?
    let recommendedTags: [String]?
    let secureTags: [String]?
    let mainRoute: Int?
    
    enum CodingKeys: String, CodingKey{
        case arrayOfPos
        case routeName
        case runningTime
        case review
        case runningDate
        case distance
        case files
        case location
        case recommendedTags
        case secureTags
        case mainRoute
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // 에러아님
        let posArray = try values.decode([[String:Double]].self, forKey: .arrayOfPos)
        let posData = posArray.map { dict in
            let latitude = dict["latitude"] ?? 0.0
            let longitude = dict["longitude"] ?? 0.0
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        arrayOfPos = posData
        
        routeName = try values.decode(String.self, forKey: .routeName)
        runningTime = try values.decode(String.self, forKey: .runningTime)
        review = try values.decode(String.self, forKey: .review)
        runningDate = try values.decode(String.self, forKey: .runningDate)
        distance = try values.decode(Double.self, forKey: .distance)
        
        // MARK: String 배열
        files = try values.decode([String].self, forKey: .files)
        
        location = try values.decode(String.self, forKey: .location)
        
        // MARK: String 배열
        recommendedTags = try values.decode([String].self, forKey: .recommendedTags)
        secureTags = try values.decode([String].self, forKey: .secureTags)
        
        mainRoute = try values.decode(Int.self, forKey: .mainRoute)
    }
    
    init(arrayOfPos: [CLLocationCoordinate2D], routeName: String,runningTime: String, review: String, runningDate: String, distance: Double, files: [String], location: String, recommendedTags: [String], secureTags: [String], mainRoute: Int){
        self.arrayOfPos = arrayOfPos
        self.routeName = routeName
        self.runningTime = runningTime
        self.review = review
        self.runningDate = runningDate
        self.distance = distance
        self.files = files
        self.location = location
        self.recommendedTags = recommendedTags
        self.secureTags = secureTags
        self.mainRoute = mainRoute
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arrayOfPos, forKey: .arrayOfPos)
        try container.encode(routeName, forKey: .routeName)
        try container.encode(runningTime, forKey: .runningTime)
        try container.encode(review, forKey: .review)
        try container.encode(runningDate, forKey: .runningDate)
        try container.encode(distance, forKey: .distance)
        try container.encode(files, forKey: .files)
        try container.encode(location, forKey: .location)
        try container.encode(recommendedTags, forKey: .recommendedTags)
        try container.encode(secureTags, forKey: .secureTags)
        try container.encode(mainRoute, forKey: .mainRoute)
    }
}


extension CLLocationCoordinate2D: Codable {
     public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(longitude, forKey: .longitude)
         try container.encode(latitude, forKey: .latitude)
     }
      
     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
    
    enum CodingKeys: String, CodingKey{
        case latitude
        case longitude
    }
 }

struct RouteId: Codable{
    let routeId: Int
    
    enum CodingKeys: String, CodingKey{
        case routeId = "routeId"
    }
}

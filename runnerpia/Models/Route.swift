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
        arrayOfPos = try decoder.singleValueContainer().decode([CLLocationCoordinate2D].self)
        routeName = try values.decode(String.self, forKey: .routeName)
        runningTime = try values.decode(String.self, forKey: .runningTime)
        review = try values.decode(String.self, forKey: .review)
        runningDate = try values.decode(String.self, forKey: .runningDate)
        distance = try values.decode(Double.self, forKey: .distance)
        
        // MARK: String 배열
        files = try decoder.singleValueContainer().decode([String].self)
        
        location = try values.decode(String.self, forKey: .location)
        
        // MARK: String 배열
        recommendedTags = try decoder.singleValueContainer().decode([String].self)
        secureTags = try decoder.singleValueContainer().decode([String].self)
        
        mainRoute = try values.decode(Int.self, forKey: .mainRoute)
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
         var container = encoder.unkeyedContainer()
         try container.encode(longitude)
         try container.encode(latitude)
     }
      
     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
 }

struct RouteId: Codable{
    let routeId: Int
    
    enum CodingKeys: String, CodingKey{
        case routeId = "routeId"
    }
}

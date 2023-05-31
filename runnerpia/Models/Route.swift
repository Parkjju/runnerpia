//
//  Route.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import Foundation
import CoreLocation
import UIKit

struct Route{
    let user: User?
    let routeName: String?
    let distance: Int?
    let arrayOfPos: [CLLocationCoordinate2D]?
    let runningTime: String?
    let review: String?
    let runningDate: String?
    let recommendedTags: [String]?
    let secureTags: [String]?
    let files: [UIImage]?
}

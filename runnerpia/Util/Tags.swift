//
//  Tags.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import Foundation
// enum refactoring
let globalRecommendedTags: [String] = ["안심등이 있어요","늦은 시간까지 사람이 많아요","강을 따라 달려요","가파른 구간이 없어요"]
let globalSecureTags: [String] = ["안심등이 있어요", "늦은 시간까지 사람이 많아요", "강을 따라 달려요", "가파른 구간이 없어요", "울창한 나무숲"]

enum NormalTags{
    case river
    case woody
    case clean
    case flat
    case walkerTrack
}

enum SecureTags{
    case schoolZone
    case safetyPole
    case streetLight
    case manyPeopleInNight
    case manyPeopleInNoon
}

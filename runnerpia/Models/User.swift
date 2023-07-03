//
//  User.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import Foundation

struct User: Codable{
    let userId: String
    let nickname: String
}

extension User{
    enum CodingKeys: String, CodingKey{
        case userId = "userId"
        case nickname = "nickname"
    }
}

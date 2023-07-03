//
//  NetworkError.swift
//  runnerpia
//
//  Created by Jun on 2023/06/21.
//

import Foundation

struct NetworkError: Codable, Error{
    let statusCode: Int
    let message: [String]
    let error: String
    
    enum CodingKeys: String, CodingKey{
        case statusCode = "statusCode"
        case message = "message"
        case error = "error"
    }
}

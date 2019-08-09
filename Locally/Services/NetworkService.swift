//
//  NetworkService.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import Foundation
import Moya

// MARK: - In your codebase define your apiKey
//let apiKey = "INSERT YOUR API KEY HERE"
private let apiKey = MyConstants.shared.apiKey

enum YelpService {
    enum BusinessProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)

        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }

        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }

        var method: Moya.Method {
            return .get
        }

        var sampleData: Data {
            return Data()
        }

        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(parameters: ["latitude": lat, "longitude": long, "limit": 10], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
        }

        var headers: [String: String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}

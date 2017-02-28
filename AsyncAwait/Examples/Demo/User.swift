//
//  User.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/26.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String

    init?(_ json: [String: Any]) {
        guard let id   = json["id"] as? Int else { return nil }
        guard let name = json["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
    }
}

extension User {
    static func create(fromJSONData data: Data) -> [User] {
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let json = jsonObject as? [[String: Any]] {
            return json.flatMap { User($0) }
        }
        return []
    }
}

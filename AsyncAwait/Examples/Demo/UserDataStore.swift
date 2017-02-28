//
//  UserDataStore.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/27.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation
import AsyncAwait

protocol UserDataStore {
    func getUsers() -> Await<[User], DataStoreError>
}

enum DataStoreError: Error {
    case unknown
}

struct UserDataStoreImpl: UserDataStore {
    func getUsers() -> Await<[User], DataStoreError> {
        return Await<[User], DataStoreError> { success, failure in
            
            let url: URL = "https://jsonplaceholder.typicode.com/users"
            URLSession.shared.dataTask(with: url) { data, response, error in
                switch (data, error) {
                case(let data?, _):
                    success(User.create(fromJSONData: data))
                default:
                    failure(.unknown)
                }
            }.resume()
        }
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(string: value)!
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(string: value)!
    }
}

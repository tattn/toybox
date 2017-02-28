//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import AsyncAwait

PlaygroundPage.current.needsIndefiniteExecution = true

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

enum DataStoreError: Error {
    case unknown
}

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


// MARK: - Playground

async {
    var users: [User] = []
    do {
        users = try await(getUsers())
    } catch DataStoreError.unknown {
        fatalError(DataStoreError.unknown.localizedDescription)
    } catch { fatalError("ここには来ない") }

    print(users)
}


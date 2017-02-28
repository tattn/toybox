//
//  Await+.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/28.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation
import AsyncAwait

// MARK: - PromiseKit
import PromiseKit

extension UserDataStore {
    func getUsersPromise() -> Promise<[User]> {
        return Promise { resolve, reject in
            let url: URL = "https://jsonplaceholder.typicode.com/users"
            URLSession.shared.dataTask(with: url) { data, response, error in
                switch (data, error) {
                case(let data?, _):
                    resolve(User.create(fromJSONData: data))
                case(_, let error?):
                    reject(error)
                default:
                    fatalError()
                }
            }.resume()
        }
    }
}

extension Promise: Awaitable {
    public func run(onSuccess: @escaping (T) -> Void, onFailure: @escaping (NSError) -> Void) {
        self.then { value in onSuccess(value) }
            .catch { error in onFailure(error as NSError) }
    }
}


// MARK: - RxSwift
import RxSwift

extension UserDataStore {
    func getUsersObservable() -> Observable<[User]> {
        return Observable.create { observer in
            let url: URL = "https://jsonplaceholder.typicode.com/users"
            URLSession.shared.dataTask(with: url) { data, response, error in
                switch (data, error) {
                case(let data?, _):
                    observer.on(.next(User.create(fromJSONData: data)))
                case(_, let error?):
                    observer.on(.error(error))
                default:
                    fatalError()
                }
                observer.on(.completed)
            }.resume()

            return Disposables.create()
        }
    }
}

extension Observable: Awaitable {
    public func run(onSuccess: @escaping (E) -> Void, onFailure: @escaping (NSError) -> Void) {
        self.subscribe(onNext: { n in onSuccess(n) },
                       onError: { e in onFailure(e as NSError) })
    }
}

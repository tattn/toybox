//
//  AsyncAwait.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/26.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public func await2<T: Awaitable>(_ awaitable: T) -> Result<T.Value, T.Error> {
    let semaphore = DispatchSemaphore(value: 0)

    var result: Result<T.Value, T.Error>! {
        didSet {
            semaphore.signal()
        }
    }

    awaitable.run(
        onSuccess: { value in result = .success(value) },
        onFailure: { error in result = .failure(error) }
    )
    
    _ = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: UINT64_MAX))

    return result
}

public func await<T: Awaitable>(_ awaitable: T) throws -> T.Value {
    let result = await2(awaitable)

    switch result {
    case .success(let value): return value
    case .failure(let error): throw error
    }
}


public func async(_ block: @escaping () -> Void) {
    DispatchQueue.global().async {
        block()
    }
}

public func main(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

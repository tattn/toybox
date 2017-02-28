//
//  Await.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/26.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public protocol Awaitable {
    associatedtype Value
    associatedtype Error: Swift.Error

    func run(onSuccess: @escaping (Value) -> Void, onFailure: @escaping (Error) -> Void)
}



public class Await<Value, Error: Swift.Error>: Awaitable {

    public typealias Block = (_ success: @escaping (Value) -> Void, _ failure: @escaping (Error) -> Void) -> Void
    private let block: Block

    public init(block: @escaping Block) {
        self.block = block
    }

    public func run(onSuccess: @escaping (Value) -> Void, onFailure: @escaping (Error) -> Void) {
        block(
            { value in onSuccess(value) },
            { error in onFailure(error) }
        )
    }
}

//
//  Result.swift
//  AsyncAwait
//
//  Created by Tatsuya Tanaka on 2017/02/26.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

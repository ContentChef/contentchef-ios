//
//  MyLogger.swift
//  ContentChefSDKTests
//
//  Created by Paolo Malpeli on 09/03/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation
@testable import ContentChefSDK

class MyLogger : Logger {
    let dateFormatter = DateFormatter()
    var level : LogLevel
    
    init(level: LogLevel) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.level = level
    }
    
    func log(message: String, level: LogLevel) {
        if level.rawValue >= self.level.rawValue {
            print("\(dateFormatter.string(from: Date())) \(level.label): \(message)")
        }
    }
}

extension LogLevel {
    var label : String {
        switch self {
        case .debug:
            return "DEBUG"
        case .error:
            return "ERROR"
        case .info:
            return "INFO"
        case .verbose:
            return "VERBOSE"
        case .warn:
            return "WARN"
        }
    }
}

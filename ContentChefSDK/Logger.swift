//
//  Logger.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 09/03/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

/**
    Enum of log levels supported by ContentChef
 */
public enum LogLevel : Int {
    case verbose, debug, info, warn, error
}

/**
   Protocol to implement in order to receive ContentChef logs
*/
public protocol Logger : class {
    func log(message: String, level: LogLevel)
}

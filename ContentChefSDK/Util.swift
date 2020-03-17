//
//  Util.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 27/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    static let iso8601DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

protocol JSONType: Decodable {
    var jsonValue: Any? { get }
}

extension Int: JSONType {
    var jsonValue: Any? { return self }
}
extension String: JSONType {
    var jsonValue: Any? { return self }
}
extension Double: JSONType {
    var jsonValue: Any? { return self }
}
extension Bool: JSONType {
    var jsonValue: Any? { return self }
}

public func ==(lhs: AnyJSONType, rhs: AnyJSONType) -> Bool {
    return lhs.equalTo(rhs)
}

/*
    Generic JSON representation type
 */
public struct AnyJSONType: JSONType, Equatable {
    let jsonValue: Any?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            jsonValue = intValue
        } else if let stringValue = try? container.decode(String.self) {
            jsonValue = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            jsonValue = boolValue
        } else if let doubleValue = try? container.decode(Double.self) {
            jsonValue = doubleValue
        } else if let value = try? container.decode(Array<AnyJSONType>.self) {
            jsonValue = value
        } else if let value = try? container.decode(Dictionary<String, AnyJSONType>.self) {
            jsonValue = value
        } else if container.decodeNil() {
            jsonValue = nil
        } else {
            throw DecodingError.typeMismatch(JSONType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON type"))
        }
    }
    
    func equalTo(_ other: AnyJSONType) -> Bool {
        if let this = self.jsonValue as? Int, let that = other.jsonValue as? Int {
            return this == that
        } else if let this = self.jsonValue as? String, let that = other.jsonValue as? String {
            return this == that
        } else if let this = self.jsonValue as? Bool, let that = other.jsonValue as? Bool {
            return this == that
        } else if let this = self.jsonValue as? Double, let that = other.jsonValue as? Double {
            return this == that
        } else if let this = self.jsonValue as? Array<AnyJSONType>, let that = other.jsonValue as? Array<AnyJSONType> {
            return this == that
        } else if let this = self.jsonValue as? Dictionary<String, AnyJSONType>, let that = other.jsonValue as? Dictionary<String, AnyJSONType> {
            return this == that
        } else {
            return false
        }
    }
}

func log(message: String, level: LogLevel, configuration: ContentChefEnvironmentConfiguration) {
    DispatchQueue.main.async {
        configuration.logger?.log(message: message, level: level)
    }
}

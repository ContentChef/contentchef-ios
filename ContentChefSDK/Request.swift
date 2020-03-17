//
//  Request.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 09/03/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

/**
    Content request struct
 */
public struct ContentRequest {
    let publicId : String
    let targetDate : Date?
    
    /**
     Content request initializer
     - Parameters:
       - publicId: publicId of the desired content.
    */
    public init(publicId: String) {
        self.publicId = publicId
        self.targetDate = nil
    }
    
    /**
     Content request initializer
     - Parameters:
       - publicId: publicId of the desired content.
       - targetDate: retrieve content in a specified date
    */
    public init(publicId: String, targetDate: Date) {
        self.publicId = publicId
        self.targetDate = targetDate
    }
    
    var asMap : [String:String] {
        var map = [String:String]()
        map["publicId"] = publicId
        if let targetDate = self.targetDate {
            map["targetDate"] = targetDate.iso8601
        }
        return map
    }
}

/**
   Search request struct.
 
 Properties description:
   * `contentDefinitions`: content definitions mnemonicIds
   * `repositories`: repositories mnemonicIds
   * `tags`: tags
   * `publicIds`: public ids of the contents
   * `targetDate`: specify a desired date of the contents
   * `skip`: number of contents to skip. Default value: 0
   * `take`: number of contents to take. Default value: 25
   * `propFilters`: Indicates the filters on indexed fields needed to be applied to published contents (it's a stringified json). Example:
      
     ~~~
       { "condition" : "AND",
         "items" : [
           { "operator":"EQUALS",
             "field":"indexedField",
             "value":"indexedValue"
           }
        ]
      }
     ~~~
*/

public struct SearchRequest {
    public var contentDefinitions : [String]? = nil
    public var repositories: [String]? = nil
    public var tags: [String]? = nil
    public var publicIds: [String]? = nil
    public var targetDate : Date? = nil
    public var skip : Int = 0
    public var take : Int = 25
    var propFilters: PropertyFilters? = nil
    
    public mutating func setPropertyFiltersBooleanOperator(_ op: BooleanOperator) {
        if propFilters == nil {
            propFilters = PropertyFilters(condition: op, items: [PropertyFilters.Item]())
        } else {
            propFilters?.condition = op
        }
    }
    
    public mutating func addPropertyFilter(operator op: FilterOperator, field: String, value: String) {
        if propFilters == nil {
            propFilters = PropertyFilters(condition: .and, items: [PropertyFilters.Item]())
        }
        propFilters?.items.append(PropertyFilters.Item(operator: op, field: field, value: value))
    }
    
    struct PropertyFilters : Codable {
        
        struct Item : Codable {
            let `operator` : FilterOperator
            let field : String
            let value : String
        }
        
        var condition: BooleanOperator
        var items: [Item]
    }
    
    /**
     Default initializer.
     
     Default values:
     * `contentDefinitions`: nil
     * `repositories`: nil
     * `tags`: nil
     * `publicIds`: nil
     * `targetDate`: nil
     * `skip`: 0
     * `take`: 25
     * `propFilters`: nil
     */
    public init() { }
    
    func asMap() throws -> [String:String] {
        var map = [String:String]()
        
        map["skip"] = "\(self.skip)"
        map["take"] = "\(self.take)"
        
        if let contentDefinitions = contentDefinitions, !contentDefinitions.isEmpty {
            map["contentDefinition"] = contentDefinitions.joined(separator: ",")
        }
        
        if let repositories = repositories, !repositories.isEmpty {
            map["repositories"] = repositories.joined(separator: ",")
        }
        
        if let tags = tags, !tags.isEmpty {
            map["tags"] = tags.joined(separator: ",")
        }
        
        if let publicIds = publicIds, !publicIds.isEmpty {
            map["publicId"] = publicIds.joined(separator: ",")
        }

        if let propFilters = self.propFilters {
            let encoder = JSONEncoder()
            let data = try encoder.encode(propFilters)
            map["propFilters"] = String(data: data, encoding: .utf8)
        }
        
        if let targetDate = self.targetDate {
            map["targetDate"] = targetDate.iso8601
        }

        return map
    }
}

public enum BooleanOperator : String, Codable {
    case and = "AND"
    case or = "OR"
}

public enum FilterOperator : String, Codable {
    case equals = "EQUALS"
    case equalIC = "EQUALS_IC"
    case contains = "CONTAINS"
    case containsIC = "CONTAINS_IC"
    case `in` = "IN"
    case inIC = "IN_IC"
    case startsWith = "STARTS_WITH"
    case startsWithIC = "STARTS_WITH_IC"
}

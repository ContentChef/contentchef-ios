//
//  Response.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 09/03/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

/**
   Content response struct
 
 Properties:
 * publicId: content public id
 * definition: content definition
 * repository: content repository
 * payload: payload generic type
 * onlineDate: content online date
 * offlineDate: content offline date
 * metadata: response metadata
 * requestContext: response request context
*/
public struct ContentResponse<T : Decodable> : Decodable {
    public let publicId: String
    public let definition: String
    public let repository: String
    public let payload: T
    public let onlineDate: Date?
    public let offlineDate: Date?
    public let metadata: ResponseMetadata
    public let requestContext: ResponseRequestContext
}

/**
   Search response struct
 
 Properties:
 * skip: number of items to skip
 * take: number of items to take
 * total: total number of items
 * items: array of contents with payload of generic type
 * requestContext: response request context
*/
public struct SearchResponse<T : Decodable> : Decodable {
    public let skip: Int
    public let take: Int
    public let total: Int
    public let items: [ContentResponse<T>]
    public let requestContext: ResponseRequestContext
}

/**
   Response metadata struct
 
 Properties:
 * id: id
 * authoringContentId: authoringContentId
 * contentVersion: content version
 * contentLastModifiedDate: content last modified date
 * tags: tags
 * publishedOn: publishing date
*/
public struct ResponseMetadata : Decodable {
    public let id: Int
    public let authoringContentId: Int
    public let contentVersion: Int
    public let contentLastModifiedDate: Date
    public let tags: [String]
    public let publishedOn: Date
}

/**
   Response request context struct

  Properties:
  * publishingChannel: publishing channel
  * targetDate: target date
  * cloudName: cloud name
  * timestamp: timestamp
*/
public struct ResponseRequestContext : Decodable {
    public let publishingChannel: String
    public let targetDate: Date?
    public let cloudName: String
    public let timestamp: Date
}

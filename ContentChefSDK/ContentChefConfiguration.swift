//
//  ContentChefConfiguration.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 26/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

/**
 Enum used to specify the `ContentChef` environment
*/
public enum ContentChefEnvironment : String {
    case staging = "staging"
    case live = "live"
}

/**
 Struct used to configure a `ContentChef` instance
*/
public struct ContentChefEnvironmentConfiguration {
    var contentChefEnvironment: ContentChefEnvironment
    var spaceId: String
    var contentChefBaseUrl: String = "https://api.contentchef.io"
    var requestFactory: RequestExecutorFactory = RemoteRequestExecutorFactory()
    var logger : Logger?
    
    /**
    Initializes a new `ContentChefEnvironmentConfiguration`.

    - Parameters:
        - environment: ContentChef environment
        - spaceId: ContentChef spaceId
        - onlineApiKey: ContentChef Online Api Key
        - previewApiKey: ContentChef Preview Api Key
        - logger: Logger instance
    - Returns: an instance of `ContentChefEnvironmentConfiguration`.
    */
    public init(environment: ContentChefEnvironment, spaceId: String, logger: Logger? = nil) {
        self.contentChefEnvironment = environment
        self.spaceId = spaceId
        self.logger = logger
    }
    
    init(environment: ContentChefEnvironment, spaceId: String, contentChefBaseUrl: String? = nil, requestFactory: RequestExecutorFactory, logger: Logger? = nil) {
        self.init(environment: environment, spaceId: spaceId, logger: logger)
        self.requestFactory = requestFactory
    }
}

enum WebService : String {
    case previewContent
    case previewSearch
    case onlineContent
    case onlineSearch
}

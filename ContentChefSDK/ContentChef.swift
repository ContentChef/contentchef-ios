//
//  ContentChef.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 26/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

/**
 `ContentChef` client that exposes methods to retrieve contents from `ContentChef`'s backend
*/
public class ContentChef {
    private let configuration: ContentChefEnvironmentConfiguration
    
    /**
    Create an client instance of `ContentChef`.

    - Parameters:
       - configuration: ContentChef environment configuration

    - Returns: an instance of `ContentChef`.
    */
    public static func instanceWith(configuration: ContentChefEnvironmentConfiguration) -> ContentChef {
        let client = ContentChef(configuration: configuration)
        
        log(message: "ContentChef Client Configured", level: .info, configuration: client.configuration)
        
        return client
    }
    
    init(configuration: ContentChefEnvironmentConfiguration) {
        self.configuration = configuration
    }
    
    /**
    Create an Online Channel instance.

    - Parameters:
       - channel: channel name

    - Returns: an Online Channel instance.
    */
    public func getOnlineChannel(channel: String) -> Channel {
        return OnlineChannel(channel: channel, configuration: configuration)
    }
    
    /**
    Create a Preview Channel instance.

    - Parameters:
       - channel: channel name

    - Returns: an Online Channel instance.
    */
    public func getPreviewChannel(channel: String) -> Channel {
        return PreviewChannel(channel: channel, configuration: configuration)
    }
}

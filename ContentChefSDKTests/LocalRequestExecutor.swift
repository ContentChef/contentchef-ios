//
//  LocalRequestExecutor.swift
//  ContentChefSDKTests
//
//  Created by Paolo Malpeli on 09/03/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation
@testable import ContentChefSDK

class LocalRequestExecutorFactory : RequestExecutorFactory {
    let bundle : Bundle
    let path : String
    
    init(bundle: Bundle, path: String) {
        self.bundle = bundle
        self.path = path
    }
    
    func getRequestExecutor() -> RequestExecutor {
        return LocalRequestExecutor(bundle: bundle, path: path)
    }
}

class LocalRequestExecutor : RequestExecutor {
    let bundle : Bundle
    let path : String

    init(bundle: Bundle, path: String) {
        self.bundle = bundle
        self.path = path
    }

    func execute<T>(params: [String:String], webService: WebService, configuration: ContentChefEnvironmentConfiguration, publishingChannel: String, apiKey: String, completion: @escaping (Result<T, ContentChefError>) -> Void) where T : Decodable {
        
        guard let path = bundle.path(forResource: webService.rawValue, ofType: "json") else {
            completion(.failure(ContentChefError.configurationError))
            return
        }
            
        let file = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(Formatter.iso8601DateFormatter)
            let value : T = try decoder.decode(T.self, from: data)
            completion(.success(value))
        } catch { error
            completion(.failure(ContentChefError.decodingError(error: error)))
        }
    }
}

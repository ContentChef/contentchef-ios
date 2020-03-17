//
//  Channel.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 27/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

public protocol Channel {
    /**
    Retrieves a content by the parameters specified in `ContentRequest`.
     - Parameters:
        - contentRequest: content request parameters instance
        - completion: closure result parameter returns a `ContentResponse` with a `payload` property of the specified type
     */
    func getContent<T: Decodable>(contentRequest: ContentRequest, completion: @escaping (Result<ContentResponse<T>,ContentChefError>)->Void)

    /**
    Retrieves a list of contents based on the search criterias specified in `SearchRequest`
     - Parameters:
        - searchRequest: content request parameters instance
        - completion: closure result parameter returns a `SearchResponse` with a `items` property as array of `ContentResponse<T>`
     */
    func search<T:Decodable>(searchRequest: SearchRequest, completion: @escaping (Result<SearchResponse<T>,ContentChefError>)->Void)
}

class OnlineChannel : Channel {
    let configuration : ContentChefEnvironmentConfiguration
    let channel : String
    
    init(channel: String, configuration: ContentChefEnvironmentConfiguration) {
        self.channel = channel
        self.configuration = configuration
        
        log(message: "\(self.self) Channel \(channel) created", level: .debug, configuration: configuration)
    }
    
    func getContent<T: Decodable>(contentRequest: ContentRequest, completion: @escaping (Result<ContentResponse<T>,ContentChefError>)->Void) {
        configuration.logger?.log(message: "Content request for \"\(contentRequest.publicId)\" started...", level: .verbose)
        
        configuration.requestFactory.getRequestExecutor().execute(params: contentRequest.asMap, webService: .onlineContent, configuration: configuration, publishingChannel: channel) { (result:Result<ContentResponse<T>, ContentChefError>) in
            switch result {
            case .success(let value):
                log(message: "Content request for \"\(contentRequest.publicId)\" finished", level: .debug, configuration: self.configuration)
                
                completion(.success(value))
            case .failure(let error):
                log(message: "Content request for \"\(contentRequest.publicId)\" finished with error: \(error.localizedDescription)", level: .error, configuration: self.configuration)

                completion(.failure(error))
            }
        }
    }

    func search<T:Decodable>(searchRequest: SearchRequest, completion: @escaping (Result<SearchResponse<T>,ContentChefError>)->Void) {
        configuration.logger?.log(message: "Search request \"\(searchRequest)\" started...", level: .verbose)
        
        guard let parameters = try? searchRequest.asMap() else {
            log(message: "Search request \"\(searchRequest)\" is invalid", level: .error, configuration: self.configuration)
            let error = ContentChefError.badRequestError(message: "Unable to handle parameters request")
            completion(.failure(error))
            return
        }
        
        configuration.requestFactory.getRequestExecutor().execute(params: parameters, webService: .onlineSearch, configuration: configuration, publishingChannel: channel) { (result:Result<SearchResponse<T>, ContentChefError>) in
            switch result {
            case .success(let value):
                log(message: "Search request for \"\(searchRequest)\" finished", level: .debug, configuration: self.configuration)
                
                completion(.success(value))
            case .failure(let error):
                log(message: "Search request for \"\(searchRequest)\" finished with error: \(error.localizedDescription)", level: .error, configuration: self.configuration)
                
                completion(.failure(error))
            }
        }
    }
}

class PreviewChannel : OnlineChannel {
    
    override func getContent<T: Decodable>(contentRequest: ContentRequest, completion: @escaping (Result<ContentResponse<T>,ContentChefError>)->Void) {
        configuration.logger?.log(message: "Content request for \"\(contentRequest.publicId)\" started...", level: .verbose)
        
        configuration.requestFactory.getRequestExecutor().execute(params: contentRequest.asMap, webService: .previewContent, configuration: configuration, publishingChannel: channel) { (result:Result<ContentResponse<T>, ContentChefError>) in
            switch result {
            case .success(let value):
                log(message: "Content request for \"\(contentRequest.publicId)\" finished", level: .debug, configuration: self.configuration)

                completion(.success(value))
            case .failure(let error):
                log(message: "Content request for \"\(contentRequest.publicId)\" finished with error: \(error.localizedDescription)", level: .error, configuration: self.configuration)

                completion(.failure(error))
            }
        }
    }

    override func search<T:Decodable>(searchRequest: SearchRequest, completion: @escaping (Result<SearchResponse<T>,ContentChefError>)->Void) {
        configuration.logger?.log(message: "Search request \"\(searchRequest)\" started...", level: .verbose)
        
        guard let parameters = try? searchRequest.asMap() else {
            log(message: "Search request \"\(searchRequest)\" is invalid", level: .error, configuration: self.configuration)
            let error = ContentChefError.badRequestError(message: "Unable to handle parameters request")
            completion(.failure(error))
            return
        }
        
        configuration.requestFactory.getRequestExecutor().execute(params: parameters, webService: .previewSearch, configuration: configuration, publishingChannel: channel) { (result:Result<SearchResponse<T>, ContentChefError>) in
            switch result {
            case .success(let value):
                log(message: "Search request for \"\(searchRequest)\" finished", level: .debug, configuration: self.configuration)

                completion(.success(value))
            case .failure(let error):
                log(message: "Search request for \"\(searchRequest)\" finished with error: \(error.localizedDescription)", level: .error, configuration: self.configuration)

                completion(.failure(error))
            }
        }
    }
}

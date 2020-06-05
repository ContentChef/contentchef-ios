//
//  RequestExecutorFactory.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 27/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

protocol RequestExecutorFactory {
    func getRequestExecutor()->RequestExecutor
}

protocol RequestExecutor {
    func execute<T>(params: [String:String], webService: WebService, configuration: ContentChefEnvironmentConfiguration, publishingChannel: String, completion: @escaping (Result<T, ContentChefError>)->Void) where T : Decodable
}

class RemoteRequestExecutorFactory : RequestExecutorFactory {
    func getRequestExecutor() -> RequestExecutor {
        return RemoteRequestExecutor()
    }
}

struct ResponseError: Codable {
    let type, message: String?
    
    /*struct Input: Codable {
        let spaceID, targetDate, publishingChannel: String?
        
        struct Filters: Codable {
            let publicID: String?
            let legacyMetadata, liveContents: Bool?

            enum CodingKeys: String, CodingKey {
                case publicID = "publicId"
                case legacyMetadata, liveContents
            }
        }
        
        let filters: Filters?

        enum CodingKeys: String, CodingKey {
            case spaceID = "spaceId"
            case targetDate, publishingChannel, filters
        }
    }
    
    let input: Input?
    
    struct ValidationsError: Codable {
        let value, property: String?
        //let children: [AnyJSONType]?
        struct Constraints: Codable {
            let isIso8601: String?
        }
        let constraints: Constraints?
    }
    
    let validationsErrors: [ValidationsError]?
 */
}

class RemoteRequestExecutor : RequestExecutor {
    func execute<T>(params: [String:String], webService: WebService, configuration: ContentChefEnvironmentConfiguration, publishingChannel: String, completion: @escaping (Result<T, ContentChefError>) -> Void) where T : Decodable {
        log(message: "RemoteRequestExecutor execute started...", level: .verbose, configuration: configuration)
        
        guard let url = self.getURL(webService: webService, configuration: configuration, publishingChannel: publishingChannel),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                log(message: "Unable to create url. publishingChannel: \(publishingChannel), webService: \(webService), params: \(params)", level: .debug, configuration: configuration)
                
            completion(.failure(ContentChefError.configurationError))
            return
        }
        
        log(message: "URL: \(url)", level: .verbose, configuration: configuration)
        
        let queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        urlComponents.queryItems = queryItems

        guard let urlWithQuery = urlComponents.url else {
            log(message: "Unable to create url. url: \(url), queryItems: \(queryItems)", level: .debug, configuration: configuration)
            
            completion(.failure(ContentChefError.genericError))
            return
        }

        log(message: "URL with query: \(urlWithQuery)", level: .verbose, configuration: configuration)
        
        var request = URLRequest(url: urlWithQuery)
        request.httpMethod = "GET"
        
        switch webService {
        case .onlineContent:
            fallthrough
        case .onlineSearch:
            request.addValue(configuration.onlineApiKey, forHTTPHeaderField: "X-Chef-Key")
        case .previewContent:
            fallthrough
        case .previewSearch:
            request.addValue(configuration.previewApiKey, forHTTPHeaderField: "X-Chef-Key")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                log(message: "Response finished with the following error: \(error)", level: .debug, configuration: configuration)
                DispatchQueue.main.async {
                    completion(.failure(ContentChefError.networkError(error: error)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                log(message: "Response finished but it's not a valid HTTP response", level: .debug, configuration: configuration)
                DispatchQueue.main.async {
                    completion(.failure(ContentChefError.invalidResponseError))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601DateFormatter)
                        let decodedData = try decoder.decode(T.self, from: data)
                        
                        log(message: "RemoteRequestExecutor http request finished successfully", level: .debug, configuration: configuration)
                        
                        DispatchQueue.main.async {
                            completion(.success(decodedData))
                        }
                    } catch {
                        log(message: "Response finished but the following error occurred decoding data: \(error)", level: .debug, configuration: configuration)
                        
                        DispatchQueue.main.async {
                            completion(.failure(ContentChefError.decodingError(error: error)))
                        }
                    }
                } else {
                    log(message: "Response finished but doesn't contain any data", level: .debug, configuration: configuration)
                    DispatchQueue.main.async {
                        completion(.failure(ContentChefError.invalidResponseError))
                    }
                }
            } else if response.statusCode == 404 {
                log(message: "Response finished but content wasn't found", level: .debug, configuration: configuration)
                DispatchQueue.main.async {
                    completion(.failure(ContentChefError.contentNotFoundError))
                }
            } else {
                if let data = data,
                    let responseError = try? decoder.decode(ResponseError.self, from: data) {
                    
                    log(message: "Response finished with error response. HTTP Status Code: \(response.statusCode), Response error: \(responseError)", level: .debug, configuration: configuration)
                    
                    DispatchQueue.main.async {
                        completion(.failure(ContentChefError.badRequestError(message: responseError.message ?? "unknown server error")))
                    }
                } else {
                    log(message: "Response finished with server error: \(response.statusCode)", level: .debug, configuration: configuration)
                    
                    DispatchQueue.main.async {
                        completion(.failure(ContentChefError.serverError))
                    }
                }
            }
        }
        
        log(message: "RemoteRequestExecutor http request started...", level: .debug, configuration: configuration)
        task.resume()
    }
    
    
    private func getURL(webService: WebService, configuration: ContentChefEnvironmentConfiguration, publishingChannel: String) -> URL? {
        switch webService {
        case .previewContent:
            return URL(string: "\(configuration.contentChefBaseUrl)/space/\(configuration.spaceId)/preview/\(configuration.contentChefEnvironment)/content/\(publishingChannel)")
        case .previewSearch:
            return URL(string: "\(configuration.contentChefBaseUrl)/space/\(configuration.spaceId)/preview/\(configuration.contentChefEnvironment)/search/v2/\(publishingChannel)")
        case .onlineContent:
            return URL(string: "\(configuration.contentChefBaseUrl)/space/\(configuration.spaceId)/online/\(configuration.contentChefEnvironment)/content/\(publishingChannel)")
        case .onlineSearch:
            return URL(string: "\(configuration.contentChefBaseUrl)/space/\(configuration.spaceId)/online/\(configuration.contentChefEnvironment)/search/v2/\(publishingChannel)")
        }
    }
}

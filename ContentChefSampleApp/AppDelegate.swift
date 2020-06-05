//
//  AppDelegate.swift
//  ContentChefSampleApp
//
//  Created by Paolo Malpeli on 27/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import UIKit
import ContentChefSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Content Chef configuration
        let configuration = ContentChefEnvironmentConfiguration(environment: .staging, spaceId: "", onlineApiKey: "", previewApiKey: "")
        // Content Chef instantiation
        let contentChef = ContentChef.instanceWith(configuration: configuration)
        
        // Online Channel query example
        // channel instantiation
        let onlineChannel = contentChef.getOnlineChannel(channel: "")
        // request instantiation
        let onlineContentRequest = ContentRequest(publicId: "")
        // content request expecting [String:AnyJSONType] type
        onlineChannel.getContent(contentRequest: onlineContentRequest) { (result : Result<ContentResponse<[String:AnyJSONType]>, ContentChefError>) in
            switch result {
            case .success(let contentResponse):
                // payload is [String:AnyJSONType] type
                print("\(contentResponse.payload)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        struct MyPayload : Decodable {
            let id : Int
            let name : String
            let date : Date
            let array : [String]
        }
        
        // content request expecting MyPayload type
        onlineChannel.getContent(contentRequest: onlineContentRequest) { (result : Result<ContentResponse<MyPayload>, ContentChefError>) in
            switch result {
            case .success(let contentResponse):
                // payload is MyPayload type
                print("\(contentResponse.payload)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        // Preview Channel query example
        // channel instantiation
        let previewChannel = contentChef.getPreviewChannel(channel: "")
        // request instantiation
        let previewContentRequest = ContentRequest(publicId: "", targetDate: Date().addingTimeInterval(60 * 60 * 24))
        // content request expecting [String:AnyJSONType] type
        previewChannel.getContent(contentRequest: previewContentRequest) { (result : Result<ContentResponse<[String:AnyJSONType]>, ContentChefError>) in
            switch result {
            case .success(let contentResponse):
                // payload is [String:AnyJSONType] type
                print("\(contentResponse.payload)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        // content request expecting MyPayload type
        previewChannel.getContent(contentRequest: previewContentRequest) { (result : Result<ContentResponse<MyPayload>, ContentChefError>) in
            switch result {
            case .success(let contentResponse):
                // payload is MyPayload type
                print("\(contentResponse.payload)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        // search request istantiation
        var onlineSearchRequest = SearchRequest()
        // search request parameters setting
        onlineSearchRequest.publicIds = ["abc","def"]
        // search request property filter Boolean operator setter
        onlineSearchRequest.setPropertyFiltersBooleanOperator(.or)
        // search request property filter setter
        onlineSearchRequest.addPropertyFilter(operator: .contains, field: "field", value: "value")
        // search request expecting [String:AnyJSONType] type
        onlineChannel.search(searchRequest: onlineSearchRequest) { (result : Result<SearchResponse<[String:AnyJSONType]>, ContentChefError>) in
            switch result {
            case .success(let searchResponse):
                // each item is [String:AnyJSONType] type
                print("\(searchResponse.items)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        // search request expecting MyPayload type
        onlineChannel.search(searchRequest: onlineSearchRequest) { (result : Result<SearchResponse<MyPayload>, ContentChefError>) in
            switch result {
            case .success(let searchResponse):
                // each item is MyPayload type
                print("\(searchResponse.items)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        
        // search request istantiation
        var previewSearchRequest = SearchRequest()
        // search request target date setter
        previewSearchRequest.targetDate = Date().addingTimeInterval(60 * 60 * 24)
        // search request parameters setting
        previewSearchRequest.publicIds = ["abc","def"]
        // search request property filter Boolean operator setter
        previewSearchRequest.setPropertyFiltersBooleanOperator(.or)
        // search request property filter setter
        previewSearchRequest.addPropertyFilter(operator: .contains, field: "field", value: "value")
        // search request expecting [String:AnyJSONType] type
        previewChannel.search(searchRequest: previewSearchRequest) { (result : Result<SearchResponse<[String:AnyJSONType]>, ContentChefError>) in
            switch result {
            case .success(let searchResponse):
                // each item is [String:AnyJSONType] type
                print("\(searchResponse.items)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        // search request expecting MyPayload type
        previewChannel.search(searchRequest: previewSearchRequest) { (result : Result<SearchResponse<MyPayload>, ContentChefError>) in
            switch result {
            case .success(let searchResponse):
                // each item is MyPayload type
                print("\(searchResponse.items)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
        return true
    }
}


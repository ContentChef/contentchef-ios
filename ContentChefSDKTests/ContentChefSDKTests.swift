//
//  ContentChefSDKTests.swift
//  ContentChefSDKTests
//
//  Created by Paolo Malpeli on 26/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import XCTest
@testable import ContentChefSDK

func testThread() {
    if Thread.current != Thread.main {
        XCTFail("Not in Main Thread")
    }
}

class ContentChefSDKTests: XCTestCase {
    var configuration : ContentChefEnvironmentConfiguration!
    var contentChef : ContentChef!
    let previewApiKey = ""
    let onlineApiKey = ""
    
    override func setUp() {
        configuration = ContentChefEnvironmentConfiguration(environment: .live, spaceId: "spaceId", requestFactory: LocalRequestExecutorFactory(bundle: Bundle(for: type(of: ContentChefSDKTests())), path: "json"), logger: MyLogger(level: .verbose))
        contentChef = ContentChef.instanceWith(configuration: configuration)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetOnlineChannel() {
        let configuration = ContentChefEnvironmentConfiguration(environment: .live, spaceId: "spaceId")
        let contentChef = ContentChef.instanceWith(configuration: configuration)
        guard let channel = contentChef.getOnlineChannel(channel: "", apiKey: "") as? OnlineChannel else {
            XCTFail("Error getting Online Channel")
            return
        }
    }
    
    func testGetPreviewChannel() {
        let configuration = ContentChefEnvironmentConfiguration(environment: .live, spaceId: "spaceId")
        let contentChef = ContentChef.instanceWith(configuration: configuration)
        guard let channel = contentChef.getPreviewChannel(channel: "", apiKey: "") as? PreviewChannel else {
            XCTFail("Error getting Preview Channel")
            return
        }
    }
    
    func testGetOnlineContent() {
        let exp = expectation(description: #function)
        
        let channel = contentChef.getOnlineChannel(channel: "", apiKey: "")
        
        let contentRequest = ContentRequest(publicId: "")
        
        channel.getContent(contentRequest: contentRequest) { (result:Result<ContentResponse<AnyJSONType>,ContentChefError>) in
            testThread()
            
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                XCTFail("Error getting Online content")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetPreviewContent() {
        let exp = expectation(description: #function)
        
        let channel = contentChef.getPreviewChannel(channel: "", apiKey: "")
        
        let contentRequest = ContentRequest(publicId: "", targetDate: Date())
        
        channel.getContent(contentRequest: contentRequest) { (result:Result<ContentResponse<AnyJSONType>,ContentChefError>) in
            testThread()
            
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                XCTFail("Error getting Preview content")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetOnlineSearch() {
        let exp = expectation(description: #function)
        
        let channel = contentChef.getOnlineChannel(channel: "", apiKey: "")
        
        let searchRequest = SearchRequest()
        
        channel.search(searchRequest: searchRequest) { (result:Result<SearchResponse<AnyJSONType>,ContentChefError>) in
            testThread()
            
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                XCTFail("Error getting Online search")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetPreviewSearchRequest() {
        let exp = expectation(description: #function)
        
        let channel = contentChef.getPreviewChannel(channel: "", apiKey: "")
        
        let searchRequest = SearchRequest()
        
        channel.search(searchRequest: searchRequest) { (result:Result<SearchResponse<AnyJSONType>,ContentChefError>) in
            testThread()
            
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                XCTFail("Error getting Preview search")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetPreviewSearchRequestWithPropertyFilters() {
        let exp = expectation(description: #function)
        
        let channel = contentChef.getPreviewChannel(channel: "", apiKey: "")
        
        var searchRequest = SearchRequest()
        searchRequest.setPropertyFiltersBooleanOperator(.and)
        searchRequest.addPropertyFilter(operator: .contains, field: "name", value: "abc")
        
        channel.search(searchRequest: searchRequest) { (result:Result<SearchResponse<AnyJSONType>,ContentChefError>) in
            testThread()
            
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                XCTFail("Error getting Preview search")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}

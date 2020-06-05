# ContentChef iOS/iPadOS/MacOS SDK
Welcome to  [ContentChef API-First CMS's](https://www.contentchef.io/)  iOS/iPadOS/MacOS SDK.

## How to use it
Import ContentChef SDK in your source file: `import ContentChefSDK`

Create your ContentChef instance like this:
```
// Content Chef configuration instantiation.
let configuration = ContentChefEnvironmentConfiguration(environment: .staging, spaceId: "{space identifier}", onlineApiKey: {online api key}, previewApiKey: {preview api key})

// Content Chef instantiation
let contentChef = ContentChef.instanceWith(configuration: configuration)
```
Replace `{space identifier}` placeholder with an actual value retrieved from your [ContentChef’s dashboard](https://app.contentchef.io/).

Replace `{online api key}` and `{preview api key}` placeholders with your api keys.

You can now use your contentChef instance to get the channel you want to use to retrieve info: you have two channels, the `OnlineChannel` and the `PreviewChannel`.

With the `OnlineChannel` you can retrieve contents which are in *live* state and which are actually visible, while with the `PreviewChannel` you can retrieve contents which are in both *stage* and *live* states and even contents that are not visible in the current date.

Both the `OnlineChannel` and the `PreviewChannel` have two methods which are `getContent()` and `search()`.

You can use the `getContent()` method to collect a specific content by its own `publicId`, for example to retrieve a single post from your blog, a single image from a gallery or a set of articles from your featured articles list. Otherwise you can use the `search()` method to find contents with multiple matching criteria, like content definition name, publishing dates and more.

## Examples
### Retrieve Content
`{publishing channel}` can be retrieved from your  [ContentChef’s dashboard](https://app.contentchef.io/) .
Retrieve the *new-header* content from the live environment:
```
// channel instantiation
let onlineChannel = contentChef.getOnlineChannel(channel: {publishing channel})

// request instantiation
let onlineContentRequest = ContentRequest(publicId: "new-header")

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
```

Preview the *new-header* content in a given future date:
```
// channel instantiation
let previewChannel = contentChef.getPreviewChannel(channel: {publishing channel})

// request instantiation
let previewContentRequest = ContentRequest(publicId: "new-header", targetDate: Date().addingTimeInterval(60 * 60 * 24))

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
```

If you prefer a specific type for the content payload, provide a custom `Decodable` type and pass it to request method as follows:
```
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
```

### Search
Search for all the contents with public ids *abc* and *def* in the live environment:
```
// search request instantiation
var onlineSearchRequest = SearchRequest()

// search request parameters setting
onlineSearchRequest.publicIds = ["abc","def"]

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
```

Preview all the contents with public ids *abc* and *def* in a given future date:
```
// search request instantiation
var previewSearchRequest = SearchRequest()

// search request target date setter
previewSearchRequest.targetDate = Date().addingTimeInterval(60 * 60 * 24)

// search request parameters setting
previewSearchRequest.publicIds = ["abc","def"]

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
```

If you prefer a specific type for the content payload, provide a custom `Decodable` type and pass it to request method as follows:
```
struct MyPayload : Decodable {
    let id : Int
    let name : String
    let date : Date
    let array : [String]
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
```

Look at `ContentChefSampleApp` in the source code for more examples.

## Installation
### Installing from GitHub through CocoaPods
ContentChef SDK is available via CocoaPods.

To install it use Podfile directives like the following:
```
pod ‘ContentChefSDK’, :git => "https://github.com/ContentChef/contentchef-ios.git", :branch => "master"
```

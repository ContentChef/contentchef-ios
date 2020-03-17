//
//  ContentChefError.swift
//  ContentChefSDK
//
//  Created by Paolo Malpeli on 27/02/2020.
//  Copyright © 2020 Zest One. All rights reserved.
//

import Foundation

public enum ContentChefError : Error {
    /// unspecified error
    case genericError
    /// ContentChefConfiguration error
    case configurationError
    /// content not found error
    case contentNotFoundError
    /// network error
    ///  - error: original network error
    case networkError(error: Error)
    /// invalid http response error
    case invalidResponseError
    /// decoding response error
    ///  - error: original decoding response error
    case decodingError(error: Error)
    /// generic ContentChef server error
    case serverError
    /// bad request error
    case badRequestError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .configurationError:
            return "Configuration error"
        case .contentNotFoundError:
            return "Content not found error"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .genericError:
            return "Generic error"
        case .invalidResponseError:
            return "Invalid response error"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError:
            return "Server error"
        case .badRequestError(let message):
            return "Bad request error: \(message)"
        }
    }
}

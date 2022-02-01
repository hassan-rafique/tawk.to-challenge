//
//  ApiError.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import Foundation

enum ApiError: Error {
    case invalidResponse
    case failToParse
    case invalidDowncasting
    case noInternet
    case notFound
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidDowncasting:
            return "Failed to downcast api response."
        case .invalidResponse:
            return "API response is invalid."
        case .failToParse:
            return "Failed to parse data into json object."
        case .noInternet:
            return "Internet connect is not available."
        case .notFound:
            return "Given URL was not found."
        }
        
    }
}

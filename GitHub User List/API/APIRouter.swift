//
//  APIRouter.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import Foundation

/// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
public protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}

enum APIRouter {
 
    case getUsersList(_ since: Int64)
    case getUserDetail(_ userName: String)
    
    private var path: String {
        switch self {
        case .getUsersList(let since):
            return "users?since=\(since)"
        case .getUserDetail(let username):
            return "users/\(username)"
        }
    }
    
    private var method: String {
        switch self {
        case .getUsersList(_), .getUserDetail(_):
            return "GET"
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        
        let serverURL = "https://api.github.com/"
        guard let url = URL(string: serverURL + path) else {
            throw ApiError.notFound
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return urlRequest
    }
}

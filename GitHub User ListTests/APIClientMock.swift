//
//  MockAPIClient.swift
//  GitHub User ListTests
//
//  Created by Hassan Rafique Awan on 31/01/2022.
//

import Foundation

class MockAPIClient {
    
    func getMockResponseForEndPoint(_ endPoint: APIRouter) -> Data? {
        
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        var bundlePath: String?
        
        switch endPoint {
        case .getUsersList(_):
            bundlePath = bundle.path(forResource: "UsersList", ofType: "json")
            
        case .getUserDetail(_):
            bundlePath = bundle.path(forResource: "UserDetails", ofType: "json")
        }
        
        if let path = bundlePath {
            return try? String(contentsOfFile: path).data(using: .utf8)
        }
        return nil
    }
    
}

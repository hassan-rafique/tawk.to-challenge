//
//  APIClient.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import Foundation
import UIKit

class APIClient {
    
    static let imageCache = NSCache<NSString, NSData>()
    
    static func request<T: Decodable>(endPoint: APIRouter, onSuccess: @escaping (T) -> Void, onFailure: @escaping (_ error: Error) -> Void) {
        
        guard let request = try? endPoint.asURLRequest() else { return }
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                onFailure(err)
                return
            }
            guard let data = data else {
                onFailure(ApiError.invalidResponse)
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                onSuccess(obj)
            } catch let jsonErr {
                print(jsonErr)
                onFailure(ApiError.failToParse)
            }
        }.resume()
        
    }
    
    static func downloadImage(with url: URL, completion: ((Result<Data, Error>) -> Void)? = nil) {
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            completion?(.success(Data(referencing: cachedImage)))
            return
        }
        
        //otherwise fire off a new download
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let error = err {
                completion?(.failure(error))
                print(error)
                return
            }
            guard let data = data else { return }
            imageCache.setObject( NSData(data: data), forKey: NSString(string: url.absoluteString))
            completion?(.success(data))
        }.resume()
    }
}

//
//  ImageDownloadOperation.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import Foundation
import CoreData


/// An operation that downloads user avatar and save it to the core data.
final class ImageDownloadOperation: NetworkOperation {
    var error: Error?
    var user: User
    let context = DataManager.shared.newPrivateContext()
    

    init(user: User) {
        self.user = context.object(with: user.objectID) as! User
    }
    
    override func main() {
        guard let avatarURL = user.avatarURL, let url = URL(string: avatarURL) else {
            self.complete(result: .failure(ApiError.notFound))
            return
        }
        
        APIClient.downloadImage(with: url) {  [unowned self]  result in
            switch result {
            case .success(let image):
                self.user.avatar = image
                DataManager.shared.saveContext(context)
                self.complete(result: .success(image))
            case .failure(let errorFound):
                print("failed to download iamge: \(errorFound.localizedDescription)")
                self.error = errorFound
                self.complete(result: .failure(errorFound))
            }
        }
    }
}

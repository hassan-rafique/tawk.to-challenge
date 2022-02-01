//
//  UserDetailData.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import Foundation


struct UserDetailData: Codable {
    
    let followers: Int64
    let following: Int64
    let login: String
    let name: String?
    let updated_at: String
    let created_at: String

}

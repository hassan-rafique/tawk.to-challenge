//
//  GitHub_User_ListTests.swift
//  GitHub User ListTests
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import XCTest
import CoreData
@testable import GitHub_User_List

class GitHub_User_ListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private let context = DataManager.shared.newPrivateContext()
    
    func testUsersList() {
        let mockAPI = MockAPIClient()
        
        let data = mockAPI.getMockResponseForEndPoint(.getUsersList(0))
        
        XCTAssertNotNil(data)
        if let data = data {
            do {
                let usersData = try JSONDecoder().decode([UserData].self, from: data)
                
                let parser = UsersListParser(usersData)
                let coreDataUsers = parser.saveDataUsingContext(context)
                XCTAssertEqual(usersData.count, coreDataUsers.count)
                
            } catch let jsonErr {
                XCTFail("Error parsing user list info: \(jsonErr)")
            }
        }
    }
    
    func testUserDetailsData() {
        let mockAPI = MockAPIClient()
        let data = mockAPI.getMockResponseForEndPoint(.getUserDetail("sbecker"))
        XCTAssertNotNil(data)

        if let data = data {
            do {
                let userDetailsData = try JSONDecoder().decode(UserDetailData.self, from: data)
                
                let parser = UserDetailsParser(userDetailsData)
                let user = parser.updateUserDetailsUingContext(context)
                XCTAssertNotNil(user)
                if let user = user {
                    XCTAssertEqual(user.login, userDetailsData.login)
                }
                
            } catch let jsonErr {
                XCTFail("Error parsing user details info: \(jsonErr)")
            }
        }
    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

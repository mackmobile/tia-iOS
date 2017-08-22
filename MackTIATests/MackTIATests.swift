//
//  MackTIATests.swift
//  MackTIATests
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit
import XCTest

class MackTIATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerLoginRequestSuccess() {
        let asyncExpectation = self.expectationWithDescription("AcessandoServidor")
        
        let server = TIAServer.sharedInstance
        server.credentials = (tia:"31445721", password:"psgb1995", campus:"001")
        server.sendRequet(ServiceURL.Login) { (jsonData, error) in
            XCTAssertNil(error, "Login não foi aceito, erro: \(error)")
            XCTAssertNotNil(jsonData, "Nenhuma resposta enviada do servidor")
            XCTAssertNotNil(jsonData as? [String:AnyObject], "O JSON deveria estar no formato [String:AnyObject]")
            XCTAssertNotNil((jsonData as? [String:AnyObject])?["resposta"], "O JSON deveria ser uma chame \"Resposta\"")
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5) { (error) in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testGradeParseJson() {
        let asyncExpectation = self.expectationWithDescription("AcessandoServidor")
        
        let server = TIAServer.sharedInstance
        server.credentials = (tia:"31445721", password:"psgb1995", campus:"001")
        server.sendRequet(ServiceURL.Grades) { (jsonData, error) in
            let parser = ListGradeWorker()
            XCTAssertNotNil(parser.parseJSON(jsonData!))
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5) { (error) in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

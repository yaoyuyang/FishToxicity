//
//  FishToxicityUITests.swift
//  FishToxicityUITests
//
//  Created by Yaoyu Yang on 1/25/16.
//  Copyright © 2016 Yaoyu Yang. All rights reserved.
//

import XCTest

class FishToxicityUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        snapshot("0Launch")
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("blue")
        snapshot("1Search")
        app.buttons["Cancel"].tap()
        tablesQuery.staticTexts["Bluefish"].tap()
        snapshot("2Show")
    }
    
}

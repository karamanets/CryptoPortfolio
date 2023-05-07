//
//  CryptoPortfolio_UI_Tests.swift
//  CryptoPortfolio_UI_Tests
//
//  Created by Alex Karamanets on 07/05/2023.
//

import XCTest

//📌 1. Name - test_[ struct or class ]_[ var or func ]_[ Expected behavior ]

//📌 2. Testing struct - Given, When, Then

final class CryptoPortfolio_UI_Tests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws { }

    func test_HomeView_StartList_ShowPortfolio() {
        // Given
        let livePricesStaticText = app.staticTexts["Live Prices"]
        
        // When
        sleep(4)
        let showPortfolioButton = app.images["Forward"]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShowSettings() {
        // Given
        let livePricesStaticText = app.staticTexts["Live Prices"]
        
        // When
        sleep(4)
        let showPortfolioButton = app.images["Forward"]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        let plusButton = app.images["Info"]
        plusButton.tap()
        
        let settingLogo = app.navigationBars["Settings"].staticTexts["Settings"]
        settingLogo.tap()
        
        let dismissButton = app.navigationBars["Settings"].buttons["arrowshape.turn.up.backward.2"]
        dismissButton.tap()
        
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldShowAddPortfolioAndGoBack() {
        // Given
        let livePricesStaticText = app.staticTexts["Live Prices"]
        
        //When
        sleep(4)
        let showPortfolioButton = app.images["Forward"]
        showPortfolioButton.tap()
        
        let plusButton = app.images["Add"]
        plusButton.tap()
        
        let dismissButton = app.navigationBars["Edit Portfolio"].buttons["arrowshape.turn.up.backward.2"]
        dismissButton.tap()
        
        showPortfolioButton.tap()
    
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldShowFirstRowWithInfo_AndGaBack() {
        // Given
        let livePricesStaticText = app.staticTexts["Live Prices"]
        
        //When
        sleep(4)
        let showPortfolioButton = app.images["Forward"]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        livePricesStaticText.tap()
        
        let rowFirst = app.collectionViews.cells.firstMatch
        rowFirst.tap()
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Overview").children(matching: .other).element(boundBy: 1)
        element.swipeUp()
        element.swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["Reed more"].tap()
        
        element.swipeUp()
        
        let info = elementsQuery.staticTexts.element(boundBy: 2)
        info.swipeUp()
        info.swipeUp()
        
        let hideInfo = elementsQuery.buttons["Hide description"]
        hideInfo.tap()
        
        let dismissButton = app.buttons["arrowshape.turn.up.backward.2"]
        dismissButton.tap()
    
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldSearch_RVN_Coin() {
        //Given
        let textField = app.textFields["Search by name or symbol ..."]
        sleep(4)
        textField.tap()
        
        //When
        let rKey = app.keys["R"]
        rKey.tap()
        
        let vKey = app.keys["v"]
        vKey.tap()
        
        let nKey = app.keys["n"]
        nKey.tap()
        
        let rowRVN_Coin = app.collectionViews.cells.firstMatch
        rowRVN_Coin.tap()
        
        let label = app.staticTexts["Ravencoin"]
               
        //Then
        XCTAssertTrue(label.exists)
    }
    
    //func test_HomeView() {}

}

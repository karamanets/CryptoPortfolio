//
//  CryptoPortfolio_UI_Tests.swift
//  CryptoPortfolio_UI_Tests
//
//  Created by Alex Karamanets on 07/05/2023.
//

import XCTest

//📌 1. Name - test_[ struct or class ]_[ var or func ]_[ Expected behavior ]

//📌 2. Testing struct - Given, When, Then

//🔥 Free API CoinGecko is limited 5 - 10 request for 5 min, if ran all tests test might will be fail -> wait 5 min and executed failed tests

final class CryptoPortfolio_UI_Tests: XCTestCase {
    
    let app = XCUIApplication()
    
    let id = accessibilityIdentifier_ID.self

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws { }

    func test_HomeView_StartList_ShowPortfolio() {
        // Given
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        // When
        sleep(4)
        let showPortfolioButton = app.images[id.rightCircleButton.rawValue]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShowSettings() {
        // Given
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        // When
        sleep(4)
        let showPortfolioButton = app.images[id.rightCircleButton.rawValue]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        let leftCircleButton = app.images[id.leftCircleButton.rawValue]
        leftCircleButton.tap()
        
        let settingLogo = app.navigationBars["Settings"].staticTexts["Settings"]
        XCTAssertTrue(settingLogo.exists)
        
        let dismissButton = app.navigationBars["Settings"].buttons[id.dismissButton.rawValue]
        dismissButton.tap()
        
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldShowAddPortfolioAndGoBack() {
        // Given
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        sleep(4)
        let rightCircleButton = app.images[id.rightCircleButton.rawValue]
        rightCircleButton.tap()
        
        let leftCircleButton = app.images[id.leftCircleButton.rawValue]
        leftCircleButton.tap()
        
        let dismissButton = app.navigationBars["Edit Portfolio"].buttons[id.dismissButton.rawValue]
        dismissButton.tap()
        
        rightCircleButton.tap()
    
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldShowFirstRowWithInfo_AndGaBack() {
        // Given
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        sleep(4)
        let showPortfolioButton = app.images[id.rightCircleButton.rawValue]
        showPortfolioButton.tap()
        showPortfolioButton.tap()
        
        livePricesStaticText.tap()
        XCTAssertTrue(livePricesStaticText.exists)
        
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
        
        let hideInfo = elementsQuery.buttons["Description_Button_ID"]
        hideInfo.tap()
        
        let dismissButton = app.buttons[id.dismissButton.rawValue]
        dismissButton.tap()
    
        // Then
        XCTAssertTrue(livePricesStaticText.exists)
    }
    
    func test_HomeView_StartList_ShouldSearch_RVN_Coin() {
        //Given
        sleep(4)
        let textField = app.textFields["home_TextField_ID"]
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
    
    func test_HomeView_FilterBar_shouldFilterLastCoinInList() {
        // Given
        sleep(4)
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        livePricesStaticText.tap()
        
        let collectionViewsQuery = app.collectionViews.cells.firstMatch
        collectionViewsQuery.tap()
        
        let dismissButton = app.buttons[id.dismissButton.rawValue]
        dismissButton.tap()
        
        let searchButtonNumber = app.staticTexts[id.searchButtonNumber.rawValue]
        searchButtonNumber.tap()
        sleep(1)
        searchButtonNumber.tap()
        sleep(1)
        collectionViewsQuery.tap()
        sleep(1)
        let lastCoinInList = app.scrollViews.otherElements.staticTexts["250"]
        sleep(1)
        lastCoinInList.tap()
        
        //Then
        XCTAssertTrue(lastCoinInList.exists)
    }
    
    func test_HomeView_FilterBar_FilterPrise_ShouldReturnTrue() {
        // Given
        sleep(4)
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        livePricesStaticText.tap()
        
        let filterPriseButton = app.staticTexts[id.searchButtonPrice.rawValue]
        filterPriseButton.tap()
        sleep(1)
        filterPriseButton.tap()
        sleep(1)
        
        let collectionViewsQuery = app.collectionViews.cells.firstMatch
        collectionViewsQuery.tap()
        
        sleep(1)
        let textChart = app.staticTexts[id.chartLabel7days.rawValue]
        textChart.tap()
         
        //Then
        XCTAssertTrue(textChart.exists)
    }
    
    func test_EditPortfolio_SearchCoin_ShouldShowAlertTryAgain() {
        // Given
        sleep(4)
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        livePricesStaticText.tap()
        
        let showPortfolioButton = app.images[id.rightCircleButton.rawValue]
        showPortfolioButton.tap()
        
        let leftCircleButton = app.images[id.leftCircleButton.rawValue]
        leftCircleButton.tap()
        sleep(1)
        
        let elementsQuery = app.scrollViews.otherElements
        let textField = elementsQuery.textFields[id.hameTextField.rawValue]
        textField.tap()
        
        let rKey = app.keys["R"]
        rKey.tap()
        
        let vKey = app.keys["v"]
        vKey.tap()
        
        let nKey = app.keys["n"]
        nKey.tap()
        
        sleep(1)
        let scrollViewsQuery = elementsQuery.scrollViews
        let rvnCoinSymbol = scrollViewsQuery.otherElements.staticTexts["RVN"]
        rvnCoinSymbol.tap()
        
        XCTAssertTrue(rvnCoinSymbol.exists)
        
        let saveButton = elementsQuery.buttons[id.portfolioSaveButton.rawValue]
        saveButton.tap()
        
        let alert = app.alerts["Try again"]
            .scrollViews.otherElements.buttons[id.alertTryAgainButton.rawValue]
        
        //Then
        XCTAssertTrue(alert.exists)
        
    }
    
    func test_EditPortfolio_SearchCoin_ShowAddAndDeleteCoinfromPortfolio() {
        // Given
        sleep(4)
        let livePricesStaticText = app.staticTexts[id.mainHeaderLabel.rawValue]
        
        //When
        livePricesStaticText.tap()
        
        let showPortfolioButton = app.images[id.rightCircleButton.rawValue]
        showPortfolioButton.tap()
        
        let leftCircleButton = app.images[id.leftCircleButton.rawValue]
        leftCircleButton.tap()
        sleep(1)
        
        let elementsQuery = app.scrollViews.otherElements
        let textField = elementsQuery.textFields[id.hameTextField.rawValue]
        textField.tap()
        
        let rKey = app.keys["R"]
        rKey.tap()
        
        let vKey = app.keys["v"]
        vKey.tap()
        
        let nKey = app.keys["n"]
        nKey.tap()
        
        sleep(1)
        let scrollViewsQuery = elementsQuery.scrollViews
        let rvnCoinSymbol = scrollViewsQuery.otherElements.staticTexts["RVN"]
        rvnCoinSymbol.tap()
        
        XCTAssertTrue(rvnCoinSymbol.exists)
        sleep(1)
        
        let amountTextField = elementsQuery.textFields[id.amountTextField.rawValue]
        amountTextField.tap()
        sleep(1)
        
        let amount = app.keyboards.keys["1"]
        amount.tap()
        
        let saveButton = elementsQuery.buttons[id.portfolioSaveButton.rawValue]
        saveButton.tap()
        sleep(1)
        
        let savedCoin = app.scrollViews.otherElements.scrollViews.otherElements.staticTexts["RVN"]
        savedCoin.tap()
        XCTAssertTrue(savedCoin.exists)
        
        amountTextField.tap()
        
        let clearAmount = elementsQuery.staticTexts["Clear amount"]
        clearAmount.tap()
        
        sleep(1)
        saveButton.tap()
        
        //Then
        let checkMark = app.navigationBars["Edit Portfolio"].otherElements["checkmark.shield"]
        XCTAssertTrue(checkMark.exists)
    }
}

enum accessibilityIdentifier_ID: String {
    
    case dismissButton        = "dismiss_Button_ID"
    case leftCircleButton     = "plus_info_Button_ID"
    case rightCircleButton    = "showPortfolio_Button_ID"
    case hameTextField        = "home_TextField_ID"
    case searchButtonNumber   = "searchOfNumber_Button_ID"
    case searchButtonPrice    = "searchOfPrice_Button_ID"
    case searchButtonHoldings = "searchOfHoldings_Button_ID"
    case refreshButton        = "refresh_Button_ID"
    case mainHeaderLabel      = "mainHeader_Label_ID"
    case descriptionButton    = "description_Button_ID"
    case portfolioSaveButton  = "portfolioSave_Button_ID"
    case alertTryAgainButton  = "alert_ButtonTryAgain_ID"
    case chartLabel7days      = "chart7Days_Label_ID"
    case amountTextField      = "amount_TextField_ID"
}

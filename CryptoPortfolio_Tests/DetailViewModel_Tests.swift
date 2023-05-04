//
//  DetailViewModel_Tests.swift
//  CryptoPortfolio_Tests
//
//  Created by Alex Karamanets on 04/05/2023.
//

import XCTest
@testable import CryptoPortfolio

//🔥 1. Name - test_[ struct or class ]_[ var or func ]_[ Expected behavior ]

//🔥 2. Testing struct - Given, When, Then


final class DetailViewModel_Tests: XCTestCase {

    func test_DetailViewModel_DetailViewModel_StartSetUp() {
        //Given
        let coin: CoinModel = TestsData.instance.coin
        
        //When
        let vm = DetailViewModel(coin: coin)
        let overviewStatistic = vm.overviewStatistic
        let detailsStatistic = vm.detailsStatistic
        
        //Then
        XCTAssertNotNil(vm.coin)
        XCTAssertEqual(vm.overviewStatistic, overviewStatistic)
        XCTAssertEqual(vm.detailsStatistic, detailsStatistic)
        XCTAssertNil(vm.coinDescription)
        XCTAssertNil(vm.redditURL)
        XCTAssertNil(vm.websiteURL)
    }
    
    func test_DetailViewModel_DetailViewModel_StartSetUp_stress() {
        
        let loopCount = Int.random(in: 0..<100)
        
        for _ in 0..<loopCount {
            //Given
            let coin: CoinModel = TestsData.instance.coin
            
            //When
            let vm = DetailViewModel(coin: coin)
            let overviewStatistic = vm.overviewStatistic
            let detailsStatistic = vm.detailsStatistic
            
            //Then
            XCTAssertNotNil(vm.coin)
            
            XCTAssertEqual(vm.overviewStatistic, overviewStatistic)
            XCTAssertEqual(vm.detailsStatistic, detailsStatistic)
            
            XCTAssertFalse(vm.overviewStatistic.isEmpty)
            XCTAssertFalse(vm.detailsStatistic.isEmpty)
            
            /// Number of items must be always the same
            XCTAssertTrue(vm.detailsStatistic.indices.count == 6)
            XCTAssertTrue(vm.overviewStatistic.indices.count == 4)
            
            XCTAssertNil(vm.coinDescription)
            XCTAssertNil(vm.redditURL)
            XCTAssertNil(vm.websiteURL)
        }
    }
    
    func test_DetailViewModel_DetailViewModel_ShouldSetUpCurrectNameForCoin_stress() {
        
        let loopCount = Int.random(in: 0..<100)
        
        for _ in 0..<loopCount {
            //Given
            let coin: CoinModel = TestsData.instance.coinRandomName
            
            //When
            let vm = DetailViewModel(coin: coin)

            //Then
            XCTAssertEqual(coin.name, vm.coin.name)
        }
    }
}

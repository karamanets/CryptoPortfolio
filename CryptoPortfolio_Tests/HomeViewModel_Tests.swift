//
//  HomeViewModel_Tests.swift
//  CryptoPortfolio_Tests
//
//  Created by Alex Karamanets on 04/05/2023.
//

import XCTest
import Combine
@testable import CryptoPortfolio

//📌 1. Name - test_[ struct or class ]_[ var or func ]_[ Expected behavior ]

//📌 2. Testing struct - Given, When, Then

//🔥 Free API CoinGecko is limited 5 - 10 request for 5 min so if ran all test twice -> get fail

final class HomeViewModel_Tests: XCTestCase {
    
    var viewModel: HomeViewModel?
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        
        viewModel = HomeViewModel(coinDataService: MockCoinDataService())
    }

    override func tearDownWithError() throws {
        
        viewModel = nil
        cancellable.removeAll()
    }
    
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
    
    func test_HomeViewModel_HomeViewModel_StartSetUp_MockData() {
        
        let loopCount = Int.random(in: 1...100)
        
        for _ in 1..<loopCount {
            //Given
            let vm = HomeViewModel(coinDataService: MockCoinDataService())
            //When
            
            //Then
            XCTAssertEqual(vm.statistic.count, 0)
            XCTAssertEqual(vm.allCoins.count, 0)
            XCTAssertEqual(vm.portfolioCoins.count, 0)
            XCTAssertEqual(vm.searchText, "")
            XCTAssertFalse(vm.isLoading)
            XCTAssertTrue(vm.sortOptions == .holdings)
        }
    }

    func test_HomeViewModel_HomeViewModel_StartSetUp_Data() {
        
        let loopCount = Int.random(in: 1...100)
        
        for _ in 1..<loopCount {
            //Given
            let vm = HomeViewModel(coinDataService: CoinDataService())
            //When
            
            //Then
            XCTAssertEqual(vm.statistic.count, 0)
            XCTAssertEqual(vm.allCoins.count, 0)
            XCTAssertEqual(vm.portfolioCoins.count, 0)
            XCTAssertEqual(vm.searchText, "")
            XCTAssertFalse(vm.isLoading)
            XCTAssertTrue(vm.sortOptions == .holdings)
        }
    }
    
    func test_HomeViewModel_HomeViewModel_StartSetUp_Data2() {
        
        let loopCount = Int.random(in: 1...100)
        
        for _ in 1..<loopCount {
            //Given
            guard let vm = viewModel else {
                XCTFail()
                return
            }
            //When
            
            //Then
            XCTAssertEqual(vm.statistic.count, 0)
            XCTAssertEqual(vm.allCoins.count, 0)
            XCTAssertEqual(vm.portfolioCoins.count, 0)
            XCTAssertEqual(vm.searchText, "")
            XCTAssertFalse(vm.isLoading)
            XCTAssertTrue(vm.sortOptions == .holdings)
        }
    }
    
    func test_CoinDataService_getCoin_shouldDownloadData() {
        //Given
        let dataService = CoinDataService()
        
        //When
        let expectation = XCTestExpectation(description: "Should download full array with 250 coins")
        
        dataService.$allCoins
            .dropFirst()
            .sink { returnCoins in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getCoins()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(dataService.allCoins.count, 250)
        XCTAssertFalse(dataService.allCoins.isEmpty)
    }
    
    func test_CoinDetailDataService_getCoinDetails_shouldDownloadDataForCoin() {
        //Given
        let dataService = CoinDetailDataService(coin: TestsData.instance.coinEmpty)
        
        //When
        let expectation = XCTestExpectation(description: "Should download detail - name and description")
        
        dataService.$coinDetails
            .dropFirst()
            .sink { returnCoin in
                guard let _ = returnCoin?.name else {
                    XCTFail()
                    return
                }
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getCoinDetails()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(dataService.coinDetails?.name == "Bitcoin")
    }
    
    
    //=====
    
    func test_CoinImageService_getCoinDetails_shouldDownloadCoinImage() {
        //Given
        let dataService = CoinImageService(coin: TestsData.instance.coin)
        
        //When
        let expectation = XCTestExpectation(description: "Should download coin Image")
        
        dataService.$image
            .sink { returnImage in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(dataService.image != nil)
    }
    
    func test_MarketDataService_getData_shouldDownloadMarketData() {
        //Given
        let dataService = MarketDataService()
        
        //When
        let expectation = XCTestExpectation(description: "Should download Market Data")
        
        dataService.$marketData
            .sink { returnMarketData in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(dataService.marketData?.marketCap != "")
    }

}

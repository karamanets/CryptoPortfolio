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

//🔥 Free API CoinGecko is limited 5 - 10 request for 5 min, if ran all tests final test will be fail -> wait 5 min and executed last test

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
    
    func test_CoinDetailDataService_getCoinDetails_shouldDownloadDataForCoinWithIDCoin() {
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
        XCTAssertFalse(dataService.coinDetails?.description?.en == "")
    }
    
    func test_CoinImageService_getCoinDetails_shouldDownloadCoinImageOrGetFromFileManager() {
        //Given
        let dataService = CoinImageService(coin: TestsData.instance.coinEmpty)
        
        //When
        let expectation = XCTestExpectation(description: "Should download coin Image")
        
        dataService.$image
            .dropFirst()
            .sink { returnImage in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getCoinImage()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(dataService.image)
    }
    
    func test_MarketDataService_getData_shouldDownloadMarketData() {
        //Given
        let dataService = MarketDataService()
        
        //When
        let expectation = XCTestExpectation(description: "Should download Market Data")
        
        dataService.$marketData
            .dropFirst()
            .sink { returnMarketData in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getData()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(dataService.marketData?.marketCap != "")
    }
    
    func test_MockCoinDataService_getCoins_shouldDownloadCoin_MockDataService() {
        //Given
        let dataService = MockCoinDataService()
        
        //When
        let expectation = XCTestExpectation(description: "Should get 100 coins from MockDataService")
        
        dataService.$allCoins
            .dropFirst()
            .sink { returnCoins in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getCoins()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(dataService.allCoins.count, 100)
    }
    
    func test_HomeViewModel_StartSetUp_MockData() {
        
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

    func test_HomeViewModel_StartSetUp_Data() {
        
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
    
    func test_HomeViewModel_StartSetUp_Data2() {
        
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
    
    func test_NetworkingManager_download_ShouldThrowError_badURLResponse() {
        //Given
        
        let url = URL(string: "https://www.google.com/")!
        
        //Then
        NetworkingManager.download(url: url)
            .sink { returnValue in
                switch returnValue {
                
                case .finished:
                    break
                case .failure( let error):
                    var asError = error as? NetworkingManager.NetworkingError
                    asError = .badURLResponse(url: url)
                    XCTAssertThrowsError(asError)
                    XCTAssertEqual(asError, NetworkingManager.NetworkingError.badURLResponse(url: url))
                }
            } receiveValue: { data in
                
            }.store(in: &cancellable)
    }
    
    func test_NetworkingManager_download_ShouldThrowError_unowned() {
        //Given
        
        let url = URL(string: "https://www.google.com/")!
        
        //Then
        NetworkingManager.download(url: url)
            .sink { returnValue in
                switch returnValue {
                
                case .finished:
                    break
                case .failure( let error):
                    var asError = error as? NetworkingManager.NetworkingError
                    asError = .unowned
                    XCTAssertThrowsError(asError)
                    XCTAssertEqual(asError, NetworkingManager.NetworkingError.unowned)
                }
            } receiveValue: { data in
                
            }.store(in: &cancellable)
    }
    
    func test_LocalFileManager_getImage_shouldReturnNil() {
        //Given
        let fileManager = LocalFileManager.instance
        
        //When
        let image = fileManager.getImage(imageName: "person", folderName: "test")
        
        //Then
        XCTAssertNil(image)
    }
    
    func test_LocalFileManager_getImage_shouldReturnImage() {
        //Given
        let fileManager = LocalFileManager.instance
        
        //When
        fileManager.saveImage(image: UIImage(systemName: "plus")!, imageName: "plus", folderName: "test")
        
        guard let image = fileManager.getImage(imageName: "plus", folderName: "test") else {
            XCTFail()
            return
        }
        
        //Then
        XCTAssertNotNil(image)
    }
    
    func test_HomeViewModel_getData_shouldDownloadCoins_InjectedService_Mock() {
        //Given
        let dataService = MockCoinDataService()
        
        let vm = HomeViewModel(coinDataService: dataService)
        
        //When
        let expectation = XCTestExpectation(description: "Should download full array of coins from MockDataService ")
        
        vm.$allCoins
            .dropFirst(2)
            .sink { returnCoins in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        dataService.getCoins()
        
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(vm.allCoins.count, 100)
    }
    
    func test_HomeViewModel_addSubscribers_shouldDownloadCoins_InjectedService() {
        //Given
        let dataService = CoinDataService()
        
        let vm = HomeViewModel(coinDataService: dataService)
        
        //When
        let expectation = XCTestExpectation(description: "Should download full array of 250 coins from CoinDataService")
        let expectation2 = XCTestExpectation(description: "Ath of bitcoin more then 60_000 -> always true")
        
        vm.$allCoins
            .dropFirst(3)
            .sink { returnCoins in
                expectation.fulfill()
                expectation2.fulfill()
            }
            .store(in: &cancellable)
        
        vm.addSubscribers()
        
        //Then
        wait(for: [expectation, expectation2], timeout: 10)
        XCTAssertEqual(vm.allCoins.count, 250)
        XCTAssertTrue(vm.allCoins.first?.ath ?? 0 > 60_000) // ⚠️ If sam time bitcoin will not be on the firs place -> Test Fail 😂
    }
}

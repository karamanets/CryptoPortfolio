//
//  PortfolioCoreDataService.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 25.04.2023.
//

import Foundation
import CoreData

final class PortfolioCoreDataService {
    
    @Published var savedEntity: [PortfolioEntity] = []
    
    private let container: NSPersistentContainer
    private let nameOfContainer = "PortfolioData"
    private let nameOfEntity = "PortfolioEntity"
    
    init() {
        container = NSPersistentContainer(name: nameOfContainer)
        container.loadPersistentStores { _ , error in
            if let error = error {
                print("[🔥] Error download CoreData: \(error.localizedDescription)")
            }
        }
        getPortfolio()
    }
    
    //MARK: - Publik methods
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        /// Check is there coin or not
        if let entity = savedEntity.first(where: { $0.coinID == coin.id }) {
            
            if amount > 0 {
                updateCoin(entity: entity, amount: amount) /// If amount more 0 -> update
            } else {
                deleteCoin(entity: entity)                 /// If amount less then 0 -> delete because its doesn't need anymore
            }
        } else {
            addCoin(coin: coin, amount: amount)            /// If container doesn't contain id of coin -> add
        }
    }
    
    //MARK: - Private methods
    /// Add new coin
    private func addCoin(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    /// Update coin amount
    private func updateCoin(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    /// Delete coin from CoreData
    private func deleteCoin(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    /// Get all portfolio data
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: nameOfEntity)
        do {
            savedEntity = try container.viewContext.fetch(request)
        } catch let error {
            print("[🔥] Error fetching CoreData: \(error.localizedDescription)")
        }
    }
    
    /// Save in CoreData
    private func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("[🔥] Error saving CoreData: \(error.localizedDescription)")
        }
    }
    
    /// Reload all CoreData
    private func applyChanges() {
        saveData()
        getPortfolio()
    }
}

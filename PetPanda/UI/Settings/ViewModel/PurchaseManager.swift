//
//  PurchaseManager.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 22.01.2026.
//

import Foundation
import StoreKit
import Combine
import SwiftUI

@MainActor
class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    let exportID = "premium_export_data"
    let themeID = "premium_theme_pack"
    
    @Published var products: [Product] = []
    
    @AppStorage("is_export_unlocked") var isExportUnlocked: Bool = false
    @AppStorage("is_theme_unlocked") var isThemeUnlocked: Bool = false
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = Task {
            for await verification in Transaction.updates {
                if let transaction = try? checkVerified(verification) {
                    await process(transaction)
                    await transaction.finish()
                }
            }
        }
        
        Task {
            await fetchProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(for: [exportID, themeID])
            print("Products fetched: \(products.map { $0.id })")
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
    
    func purchase(_ productID: String) async -> Bool {
        guard let product = products.first(where: { $0.id == productID }) else {
            print("Product not found in fetched list. Try fetching again.")
            await fetchProducts() // Попытка подгрузить, если пусто
            return false
        }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await process(transaction)
                await transaction.finish()
                return true
            case .userCancelled:
                return false
            case .pending:
                return false
            default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }
    
    func restore() async -> Bool {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            return isExportUnlocked || isThemeUnlocked
        } catch {
            return false
        }
    }
    
    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                await process(transaction)
            }
        }
    }
    
    private func process(_ transaction: StoreKit.Transaction) async {
        if transaction.productID == exportID {
            isExportUnlocked = true
        }
        if transaction.productID == themeID {
            isThemeUnlocked = true
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }
}

enum StoreError: Error { case failedVerification }

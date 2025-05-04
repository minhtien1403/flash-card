//
//  PremiumPurchaseViewModel.swift
//  FlashCard
//
//  Created by tientm on 10/01/2024.
//

import Foundation
import StoreKit

class PremiumPurchaseViewModel: ObservableObject {
    
    private let purchaseManager = PurchaseManager.shared
    @Published var isPurchasing = false
    
    func getPrice(for product: Product) -> String {
        let name = product.displayName
        let price = product.displayPrice
        let formatter = product.priceFormatStyle
        Log.info(formatter.format(product.price))
        PurchaseManager.shared.getPurchaseProduct().forEach { id in
            Log.info("Purchase: \(id)")
        }
        return "\(name) \(price)"
    }
    
    @MainActor
    func purchase(by id: String) async throws {
        isPurchasing = true
        try await purchaseManager.purchase(by: id)
        isPurchasing = false
    }
}

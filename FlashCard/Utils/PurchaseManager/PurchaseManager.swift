//
//  PurchaseManager.swift
//  FlashCard
//
//  Created by tientm on 09/01/2024.
//

import StoreKit

final class PurchaseManager {
    
    static let shared = PurchaseManager()
    
    init() {
        updateListenerTask = listenForTransaction()
        Task {
            try await loadProduct()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    private var products: [Product] = []
    private var purchasedProductIDs = Set<String>()
    private var productsLoaded = false
    private let productIds = Constant.Premium.productIds.map { $0.rawValue }
    var updateListenerTask: Task<Void, Error>? = nil
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    
    func loadProduct() async throws {
        guard !productsLoaded else { return }
        products = try await Product.products(for: productIds)
        productsLoaded = true
        for product in products {
            Log.info(product.displayName)
        }
    }
    
    func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVeified(result)
                    
                    //the transaction is verified, deliver the content to the user
                    await self.updateCustomerProductStatus()
                    
                    //Always finish a transaction
                    await transaction.finish()
                } catch {
                    //storekit has a transaction that fails verification, don't delvier content to the user
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func purchase(by id: String) async throws {
        let prd = products.first {
            $0.id == id
        }
        guard let product = prd else {
            throw PurchaseError.notFoundProduct
        }
        try await purchase(product: product)
    }
    
    private func purchase(product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .unverified(let signedType, let verificationError):
                Log.info("Purchase success but unverified: \(signedType) - \(verificationError.localizedDescription)")
            case .verified(let signedType):
                await signedType.finish()
                await updateCustomerProductStatus()
            }
        case .userCancelled:
            Log.info("User cancel purchase")
            break
        case .pending:
            Log.info("User pending purchase")
            break
        @unknown default:
            Log.info("Unknow error when purchase product")
        }
    }

    
    func checkVeified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.failedVerify
        case .verified(let signedType):
            return signedType
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                //again check if transaction is verified
                let transaction = try checkVeified(result)
                // since we only have one type of producttype - .nonconsumables -- check if any storeProducts matches the transaction.productID then add to the purchasedCourses
                Log.info("Transaction: \(transaction.productID)")
                if let product = products.first(where: { $0.id == transaction.productID}) {
                    Log.info("Purchase: \(product.id)")
                    purchasedProductIDs.insert(product.id)
                }
            } catch {
                //storekit has a transaction that fails verification, don't delvier content to the user
                print("Transaction failed verification")
            }
        }
    }
    
    func isPurchased(_ product: Product) async throws -> Bool {
        return purchasedProductIDs.contains(product.id)
    }
    
    func getProduct() -> [Product] {
        products
    }
    
    func getPurchaseProduct() -> [String] {
        purchasedProductIDs.map {
            $0
        }
    }
    
    enum PurchaseError: Error {
        
        case notFoundProduct
        case failedVerify
    }
    
    func restorePurchase() async throws {
        do {
            try await AppStore.sync()
        } catch {
            Log.warning(error.localizedDescription)
        }
    }
}

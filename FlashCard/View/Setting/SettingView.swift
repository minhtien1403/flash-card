//
//  SettingView.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var localizationServices: LocalizationServices
    @State private var isShowingPremiumSuggestPopup = false
    @State private var isRestoringPurchase = false
    private var purchaseManager = PurchaseManager.shared

    var body: some View {
        BaseView {
            List(content: {
                Section("Pro") {
                    ForEach(PurchaseItem.allCases, id: \.self) { item in
                        HStack(content: {
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            switch item {
                            case .buyProVersion:
                                navigator.push(to: .purchase)
                            case .restorePurchase:
                                isRestoringPurchase.toggle()
                                Task {
                                    do {
                                        try await PurchaseManager.shared.restorePurchase()
                                        isRestoringPurchase.toggle()
                                    } catch {
                                        isRestoringPurchase.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                Section("Utilities") {
                    ForEach(SettingItem.allCases, id: \.self) { item in
                        HStack(content: {
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            switch item {
                            case .syncData:
                                if purchaseManager.hasUnlockedPro {
                                    navigator.push(to: .syncData)
                                } else {
                                    isShowingPremiumSuggestPopup.toggle()
                                }
                            case .language:
                                navigator.push(to: .languageSetting)
                            }
                        }
                    }
                }
            })
            .padding(.vertical, 10)
            .background(AppColor.navigationBar)
            .navigationTitle(Text(.settingTabTitle))
            .popup(isPresented: $isShowingPremiumSuggestPopup) {
                PremiumPopup(text: .unlockPremiumMessage) {
                    isShowingPremiumSuggestPopup.toggle()
                    navigator.push(to: .purchase)
                } onCancel: {
                    isShowingPremiumSuggestPopup.toggle()
                }
            }
            if isRestoringPurchase {
                ProgressView().controlSize(.large)
            }
        }
    }
}

#Preview {
    NavigationView(content: {
        SettingView()
    })
}

enum SettingItem: CaseIterable {
    
    case language
    case syncData
    
    var title: AppString {
        switch self {
        case .language:
            return .language
        case .syncData:
            return .syncData
        }
    }
}

enum PurchaseItem: CaseIterable {
    
    case buyProVersion
    case restorePurchase
    
    var title: AppString {
        switch self {
        case .buyProVersion:
            return .purchasePro
        case .restorePurchase:
            return .restorePurchase
        }
    }
}

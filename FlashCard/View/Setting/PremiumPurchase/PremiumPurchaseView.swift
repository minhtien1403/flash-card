//
//  PremiumPurchaseView.swift
//  FlashCard
//
//  Created by tientm on 10/01/2024.
//

import SwiftUI

struct PremiumPurchaseView: View {
    
    @StateObject private var viewmodel = PremiumPurchaseViewModel()
    @State private var selectedPlan: AppProduct = .monthly
    @Environment(\.openURL) var openURL
    
    var body: some View {
        BaseView {
            ScrollView {
                VStack( content: {
                    Text("Subscribe to premium to receive the following benefits")
                        .multilineTextAlignment(.center)
                        .font(.custom(AppFont.mplusBold, size: 24))
                    ForEach(Constant.Premium.benefits) { benefit in
                        HStack(content: {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                            Text(benefit)
                                .font(.custom(AppFont.mplusRegular, size: 18))
                            Spacer()
                        })
                        .padding(.leading)
                        .padding(.vertical, 5)
                    }
                    Spacer(minLength: 25)
                    ForEach(Constant.Premium.productIds, id: \.self) { product in
                        Button(action: {
                            selectedPlan = product
                        }, label: {
                            Text(product.text)
                                .frame(width: Constant.Screen.width - 40, height: 40)
                                .background(selectedPlan == product ? AppColor.blue : .white)
                                .foregroundStyle(selectedPlan == product ? .white : .black)
                                .font(.custom(AppFont.mplusRegular, size: 20))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.black, lineWidth: 2)
                                }
                        })
                    }
                    Text(selectedPlan.note)
                        .font(.custom(AppFont.mplusBold, size: 18))
                        .multilineTextAlignment(.center)
                        .frame(width: Constant.Screen.width - 100)
                    Button(action: {
                        // Purchase
                        Task {
                            do {
                                try await viewmodel.purchase(by: selectedPlan.rawValue)
                            } catch {
                                Log.warning(error.localizedDescription)
                            }
                        }
                    }, label: {
                        Text(.continuePurchase)
                            .frame(width: Constant.Screen.width - 40, height: 52)
                            .background(AppColor.blue)
                            .foregroundStyle(.white)
                            .font(.custom(AppFont.mplusBold, size: 25))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    })
                    .padding(.top, 30)
                    Button {
                        if let url = URL(string: "https://minhtien1403.github.io/My-FlashCard/TermOfUse") {
                            openURL(url)
                        }
                    } label: {
                        Text(.termOfServices)
                            .underline()
                            .foregroundStyle(AppColor.blue)
                    }
                    .padding()
                    Button {
                        if let url = URL(string: "https://minhtien1403.github.io/My-FlashCard/PrivacyPolicy") {
                            openURL(url)
                        }
                    } label: {
                        Text(.privacyPolicy)
                            .underline()
                            .foregroundStyle(AppColor.blue)
                    }

                })
                .navigationTitle("Premium")
            }
            if viewmodel.isPurchasing {
                ProgressView()
                    .controlSize(.large)
            }
        }
    }
}

#Preview {
    NavigationView(content: {
        PremiumPurchaseView()
    })
}

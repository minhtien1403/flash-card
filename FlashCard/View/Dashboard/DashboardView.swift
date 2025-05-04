//
//  DashboardView.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var localizationServices: LocalizationServices
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isShowingCreateDeckPopup = false
    @State private var isShowingDeleteDeckPopup = false
    @State private var isShowingPremiumSuggestPopup = false
    @State private var deleteID: String = ""
    
    var body: some View {
        BaseView {
            deckList
                .padding(.all, .zero)
                .navigationTitle(Text(.dashboardTabTitle))
            }
            .onAppear(perform: {
                viewModel.getAllDecks()
            })
    }
    
    @ViewBuilder
    private var deckList: some View {
        ZStack(alignment: .bottomTrailing, content: {
            if viewModel.decks.isEmpty {
                VStack(content: {
                    floatingButton
                    Text(.emptyDeckMessage)
                        .font(.custom(AppFont.mplusBold, size: 16))
                        .multilineTextAlignment(.center)
                })
            } else {
                ScrollView {
                    VStack(content: {
                        ForEach(viewModel.decks) { deck in
                            DeckItem(deck: deck) { id in
                                deleteID = id
                                isShowingDeleteDeckPopup.toggle()
                            }
                            .onTapGesture {
                                Log.info("Tap to deck \(deck.id)")
                                navigator.push(to: .cardList(deckID: deck.id))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    })
                    .padding(.bottom, 80)
                }
                floatingButton
                    .padding([.trailing, .bottom], 20)
            }
        })
        .popup(isPresented: $isShowingCreateDeckPopup) {
            AddDeckPopup { deckName in
                viewModel.addDeck(deck: Deck(name: deckName,
                                             createdDate: Date().toString(),
                                             lastAccessDate: Date().toString()))
                isShowingCreateDeckPopup.toggle()
            } onCancel: {
                isShowingCreateDeckPopup.toggle()
            }
        }
        .popup(isPresented: $isShowingDeleteDeckPopup) {
            DeleteDeckPopup {
                viewModel.deleteDeck(by: deleteID)
                isShowingDeleteDeckPopup.toggle()
            } onCancel: {
                deleteID = ""
                isShowingDeleteDeckPopup.toggle()
            }
        }
        .popup(isPresented: $isShowingPremiumSuggestPopup) {
            PremiumPopup(text: .unlockPremiumForMoreDeck) {
                navigator.push(to: .purchase)
                isShowingPremiumSuggestPopup.toggle()
            } onCancel: {
                isShowingPremiumSuggestPopup.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var floatingButton: some View {
        Button(action: {
            if PurchaseManager.shared.hasUnlockedPro {
                isShowingCreateDeckPopup.toggle()
            } else {
                Log.info("Count: \(viewModel.decks.count)")
                if viewModel.decks.count >= 5 {
                    isShowingPremiumSuggestPopup.toggle()
                } else {
                    isShowingCreateDeckPopup.toggle()
                }
            }
        }, label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(AppColor.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        })
    }
}

#Preview {
    NavigationView(content: {
        DashboardView()
    })
}

struct ProfileIcon: View {
    
    var body: some View{
        Button(action: {
            print("Profile button was tapped")
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColor.blue)
                .frame(width: 36, height: 36)
        }
        .padding([.top, .trailing], 20)
        .background(AppColor.navigationBar)
    }
}

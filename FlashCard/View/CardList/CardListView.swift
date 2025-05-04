//
//  CardListView.swift
//  FlashCard
//
//  Created by tientm on 24/12/2023.
//

import SwiftUI

struct CardListView: View {
    
    @StateObject var viewModel: CardListViewModel
    @State private var currentIndex: Int = 0
    @State private var isShowingAddCardPopup: Bool = false
    @State private var isShowingDeleteCardPopup: Bool = false
    @State private var isShowingEditCardPopup: Bool = false
    @State private var isShowingCreateQuizzPopup: Bool = false
    @State private var isShowingPremiumSuggestPopup: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var localizationServices: LocalizationServices
    let cardPadding = Constant.Screen.width * 0.73
    
    init(deckID: String) {
        Log.info("Init card list view")
        _viewModel = StateObject(wrappedValue: CardListViewModel(deckID: deckID))
    }
    
    var isEditButtonDisable: Bool {
        viewModel.cards.count == 0
    }
    
    var isDeleteButtonDisable: Bool {
        viewModel.cards.count == 0
    }
    
    var body: some View {
        BaseView {
            VStack(content: {
                cardsCarousel
                cardCounter
                    .padding(.top, 40)
                utilsBar
                    .padding(.top, 40)
            })
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .popup(isPresented: $isShowingAddCardPopup, view: {
                AddCardPopup { front, back in
                    viewModel.addCard(front, back)
                    isShowingAddCardPopup.toggle()
                } onCancel: {
                    isShowingAddCardPopup.toggle()
                }
            })
            .popup(isPresented: $isShowingDeleteCardPopup) {
                DeleteCardPopup {
                    onDelete()
                } onCancel: {
                    isShowingDeleteCardPopup.toggle()
                }
            }
            .popup(isPresented: $isShowingEditCardPopup) {
                EditCardPopup(onAdd: { card in
                    viewModel.updateCard(card: card)
                    isShowingEditCardPopup.toggle()
                }, onCancel: { card in
                    isShowingEditCardPopup.toggle()
                    viewModel.restoreCardState(card: card)
                }, card: $viewModel.cards[safe: currentIndex] ?? .constant(Card(deckID: "")))
            }
            .popup(isPresented: $isShowingCreateQuizzPopup) {
                PlayQuizPopup(max: viewModel.cards.count) { numberOfQuizz in
                    isShowingCreateQuizzPopup.toggle()
                    navigator.push(to: .quizz(deckID: viewModel.getDeckID(), numberOfQuizz: numberOfQuizz))
                } onCancel: {
                    isShowingCreateQuizzPopup.toggle()
                }

            }
            .popup(isPresented: $isShowingPremiumSuggestPopup) {
                PremiumPopup(text: .unlockPremiumForMoreCard) {
                    isShowingPremiumSuggestPopup.toggle()
                    navigator.push(to: .purchase)
                } onCancel: {
                    isShowingPremiumSuggestPopup.toggle()
                }

            }
        }
        .onAppear(perform: {
            viewModel.getAllCard()
        })
        .toolbar(.hidden, for: .tabBar)
        
    }
    
    @ViewBuilder
    private var cardsCarousel: some View {
        ZStack(content: {
            ForEach(0..<viewModel.cards.count, id: \.self) { index in
                CardItem(card: $viewModel.cards[index])
                    .opacity(currentIndex == index ? 1 : 0.5)
                    .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                    .offset(x: CGFloat(index - currentIndex) * (cardPadding),
                            y: 0)
                    .zIndex(index == currentIndex ? 1 : 0)
            }
        })
        .gesture(
            DragGesture()
                .onEnded({ value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        withAnimation {
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            currentIndex = min(viewModel.cards.count - 1, currentIndex + 1)
                        }
                    }
                })
        )
    }
    
    @ViewBuilder
    private var cardCounter: some View {
        if viewModel.cards.count == 0 {
            VStack(content: {
                Text(.notCreateAnyCardYet)
                    .font(.custom(AppFont.mplusBold, size: 20))
                    .multilineTextAlignment(.center)
            })
        } else {
            HStack(content: {
                Text("\(currentIndex + 1) / \(viewModel.cards.count)")
                    .font(.custom(AppFont.mplusBold, size: 28))
            })
        }
    }
    
    @ViewBuilder
    private var utilsBar: some View {
        HStack(content: {
            Spacer()
            playQuizButton
            Spacer()
            deleteButton
            Spacer()
            editCardButton
            Spacer()
            addCardButton
            Spacer()
        })
    }
    
    @ViewBuilder
    private var playQuizButton: some View {
        Button(action: {
            isShowingCreateQuizzPopup.toggle()
        }, label: {
            VStack(content: {
                Image(systemName: "checkmark.bubble.fill")
                    .font(.largeTitle)
                    .tint(.yellow)
                Text(.quizz)
                    .font(.custom(AppFont.mplusRegular, size: 12))
                    .tint(.yellow)
            })
        })
        .opacity(isEditButtonDisable ? 0.5 : 1)
        .disabled(viewModel.cards.count == 0)
    }
    
    @ViewBuilder
    private var addCardButton: some View {
        Button(action: {
            if PurchaseManager.shared.hasUnlockedPro {
                isShowingAddCardPopup.toggle()
            } else {
                if viewModel.cards.count >= 20 {
                    isShowingPremiumSuggestPopup.toggle()
                }  else {
                    isShowingAddCardPopup.toggle()
                }
            }
        }, label: {
            VStack(content: {
                Image(systemName: "plus.circle")
                    .tint(.blue)
                    .font(.largeTitle)
                Text(.addCard)
                    .tint(.blue)
                    .font(.custom(AppFont.mplusRegular, size: 12))
            })
        })
    }
    
    @ViewBuilder
    private var editCardButton: some View {
        Button(action: {
            isShowingEditCardPopup.toggle()
        }, label: {
            VStack(content: {
                Image(systemName: "square.and.pencil")
                    .tint(.mint)
                    .font(.largeTitle)
                Text(.editCard)
                    .tint(.mint)
                    .font(.custom(AppFont.mplusRegular, size: 12))
            })
        })
        .opacity(isEditButtonDisable ? 0.5 : 1)
        .disabled(isEditButtonDisable)
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button(action: {
            isShowingDeleteCardPopup.toggle()
        }, label: {
            VStack(content: {
                Image(systemName: "trash.fill")
                    .tint(.red)
                    .font(.largeTitle)
                Text(.delete)
                    .tint(.red)
                    .font(.custom(AppFont.mplusRegular, size: 12))
            })
        })
        .opacity(isDeleteButtonDisable ? 0.5 : 1)
        .disabled(isDeleteButtonDisable)
    }
    
    private func onDelete() {
        viewModel.deleteCard(card: viewModel.cards[currentIndex]) {
            if currentIndex == viewModel.cards.count {
                withAnimation {
                    currentIndex -= 1
                }
            }
        }
        isShowingDeleteCardPopup.toggle()
    }
}

#Preview {
    NavigationView(content: {
        CardListView(deckID: "6A51198F-FB42-4E5C-9D99-10762F4A32F6")
    })
}

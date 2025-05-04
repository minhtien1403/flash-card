//
//  EditCardPopup.swift
//  FlashCard
//
//  Created by tientm on 29/12/2023.
//

import SwiftUI

struct EditCardPopup: View {
    
    var onEdit: (_ card: Card) -> Void
    var onCancel: (_ previousCard: Card) -> Void
    @Binding private var card: Card
    private var previousCard: Card
    
    
    init(onAdd: @escaping (_ card: Card) -> Void,
         onCancel: @escaping (_ previousCard: Card) -> Void,
         card: Binding<Card>) {
        self.onEdit = onAdd
        self.onCancel = onCancel
        self._card = card
        previousCard = card.wrappedValue
    }
    
    var isCreateButtonEnable: Bool {
        card.back.isEmpty || card.front.isEmpty
    }
    
    var body: some View {
        ZStack(content: {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.7,
                       height: Constant.Screen.width * 0.7)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 10, x: -10, y: 10)
            VStack(content: {
                Text(.editCardContent)
                    .font(.custom(AppFont.mplusBold, size: 20))
                TextField(AppString.enterFrontCard.rawValue.localized(), text: $card.front)
                    .padding(4)
                    .frame(width: Constant.Screen.width * 0.6, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                TextField(AppString.enterBackCard.rawValue.localized(), text: $card.back)
                    .padding(4)
                    .frame(width: Constant.Screen.width * 0.6, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                HStack(spacing: 20, content: {
                    Button(action: {
                        // dismiss
                        Log.info(previousCard.front)
                        onCancel(previousCard)
                        resignFocus()
                    }, label: {
                        Text(.cancelButton)
                            .frame(width: 60)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.red)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                    Button(action: {
                        onEdit(card)
                        resignFocus()
                    }, label: {
                        Text(.done)
                            .frame(width: 60)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(AppColor.blue)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                    .opacity(isCreateButtonEnable ? 0.5 : 1)
                    .disabled(isCreateButtonEnable)
                })
                .padding(.top)
            })
        })
    }
    
    private func resignFocus() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to:nil,
                                        from:nil,
                                        for:nil)
    }
}

#Preview {
    EditCardPopup(onAdd: { card in
        
    }, onCancel: { _ in
        
    }, card: .constant(Card(deckID: "")))
}

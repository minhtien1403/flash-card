//
//  AddDeckPopup.swift
//  FlashCard
//
//  Created by tientm on 23/12/2023.
//

import SwiftUI

struct AddDeckPopup: View {
    
    var onAdd: (_ deckName: String) -> Void
    var onCancel: () -> Void
    @State private var deckName: String = ""
    
    init(onAdd: @escaping (_ deckName: String) -> Void, onCancel: @escaping () -> Void) {
        self.onAdd = onAdd
        self.onCancel = onCancel
    }
    
    var isCreateButtonDisable: Bool {
        deckName.isEmpty
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
                Text(.addNewDeck)
                    .font(.custom(AppFont.mplusBold, size: 20))
                TextField(AppString.enterDeckName.rawValue.localized(), text: $deckName)
                    .padding(4)
                    .frame(width: Constant.Screen.width * 0.6, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                HStack(spacing: 20, content: {
                    Button(action: {
                        // dismiss
                        onCancel()
                        deckName = ""
                        resignFocus()
                    }, label: {
                        Text(.cancelButton)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.red)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                    Button(action: {
                        onAdd(deckName)
                        deckName = ""
                        resignFocus()
                    }, label: {
                        Text(.createButton)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(AppColor.blue)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                    .opacity(isCreateButtonDisable ? 0.5 : 1)
                    .disabled(isCreateButtonDisable)
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

    AddDeckPopup { deckName in
        
    } onCancel: {
        
    }

}

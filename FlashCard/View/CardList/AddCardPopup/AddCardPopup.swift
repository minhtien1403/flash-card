//
//  AddCardPopup.swift
//  FlashCard
//
//  Created by tientm on 26/12/2023.
//

import SwiftUI

struct AddCardPopup: View {
    
    var onAdd: (_ front: String, _ back: String) -> Void
    var onCancel: () -> Void
    @State private var frontCard: String = ""
    @State private var backCard: String = ""
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case front
        case none
        case back
    }
    
    init(onAdd: @escaping (_ front: String, _ back: String) -> Void,
         onCancel: @escaping () -> Void) {
        self.onAdd = onAdd
        self.onCancel = onCancel
    }
    
    var isCreateButtonEnable: Bool {
        frontCard.isEmpty || backCard.isEmpty
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
                Text(.addNewCard)
                    .font(.custom(AppFont.mplusBold, size: 20))
                TextField(AppString.enterFrontCard.rawValue.localized(), text: $frontCard)
                    .padding(4)
                    .frame(width: Constant.Screen.width * 0.6, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                    .focused($focusedField, equals: .front)
                    .onSubmit {
                        focusedField = .back
                    }
                TextField(AppString.enterBackCard.rawValue.localized(), text: $backCard)
                    .padding(4)
                    .frame(width: Constant.Screen.width * 0.6, height: 40)
                    .focused($focusedField, equals: .back)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                HStack(spacing: 20, content: {
                    Button(action: {
                        // dismiss
                        onCancel()
                        clearContent()
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
                        onAdd(frontCard, backCard)
                        clearContent()
                    }, label: {
                        Text(.createButton)
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
    
    private func clearContent() {
        backCard = ""
        frontCard = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

#Preview {
    AddCardPopup { _, _ in
        
    } onCancel: {
        
    }

}

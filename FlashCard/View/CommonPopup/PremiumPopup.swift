//
//  PremiumPopup.swift
//  FlashCard
//
//  Created by tientm on 11/01/2024.
//

import SwiftUI

struct PremiumPopup: View {
    
    var text: AppString
    var onGoToPremium: () -> Void
    var onCancel: () -> Void
    
    init(text: AppString,  onGoToPremium: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onGoToPremium = onGoToPremium
        self.onCancel = onCancel
        self.text = text
    }
    
    var body: some View {
        ZStack(content: {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.7,
                       height: Constant.Screen.width * 0.4)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 10, x: -10, y: 10)
            VStack(content: {
                Text(text)
                    .frame(width: Constant.Screen.width * 0.65)
                    .multilineTextAlignment(.center)
                    .font(.custom(AppFont.mplusBold, size: 20))
                HStack(spacing: 20, content: {
                    Button(action: {
                        // dismiss
                        onCancel()
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
                        onGoToPremium()
                    }, label: {
                        Text("Subcribe")
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(AppColor.blue)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                })
            })
        })
    }
}

#Preview {
    PremiumPopup(text: .unlockPremiumMessage, onGoToPremium: {}, onCancel: {})
}

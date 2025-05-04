//
//  SubmitPopup.swift
//  FlashCard
//
//  Created by tientm on 04/01/2024.
//

import SwiftUI

struct SubmitPopup: View {
    
    var onCancel: () -> Void
    var onFinish: () -> Void
    
    init(onFinish: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
        self.onFinish = onFinish
    }
    
    var body: some View {
        ZStack(content: {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.7,
                       height: Constant.Screen.width * 0.5)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 10, x: -10, y: 10)
            VStack(content: {
                Text(.finishQuizzesMessage)
                    .frame(width: Constant.Screen.width * 0.7)
                    .multilineTextAlignment(.center)
                    .font(.custom(AppFont.mplusBold, size: 20))
                HStack(spacing: 20, content: {
                    Button(action: {
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
                        onFinish()
                    }, label: {
                        Text(.finish)
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
    SubmitPopup {
        
    } onCancel: {
        
    }

}

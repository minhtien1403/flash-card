//
//  PlayQuizPopup.swift
//  FlashCard
//
//  Created by tientm on 05/01/2024.
//

import SwiftUI

struct PlayQuizPopup: View {
    
    @State private var numberOfQuizz: Int = 1
    private var max = 20
    private var min = 1
    private var onCreate: (_ numberOfQuizz: Int) -> Void
    private var onCancel: () -> Void
    
    init(max: Int, onCreate: @escaping (_: Int) -> Void, onCancel: @escaping () -> Void) {
        self.max = max
        self.onCreate = onCreate
        self.onCancel = onCancel
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.9,
                       height: Constant.Screen.width * 0.7)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 10, x: -10, y: 10)
            VStack(content: {
                Text(.createQuizzMessage)
                    .font(.custom(AppFont.mplusBold, size: 24))
                    .frame(width: Constant.Screen.width * 0.8)
                    .multilineTextAlignment(.center)
                HStack(content: {
                    Button(action: {
                        numberOfQuizz -= 1
                    }, label: {
                        Image(systemName: "minus")
                            .font(.title)
                    })
                    .disabled(numberOfQuizz <= min)
                    Text("\(numberOfQuizz)")
                        .font(.custom(AppFont.mplusBold, size: 30))
                        .padding(.horizontal, 15)
                    Button(action: {
                        numberOfQuizz += 1
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                    .disabled(numberOfQuizz >= max)
                })
                HStack(spacing: 20, content: {
                    Button(action: {
                        // dismiss
                        onCancel()
                        clearContent()
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
                        onCreate(numberOfQuizz)
                        clearContent()
                    }, label: {
                        Text(.createButton)
                            .frame(width: 60)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(AppColor.blue)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                })
            })
        }
    }
    
    private func clearContent() {
        numberOfQuizz = 1
    }
}

#Preview {
    PlayQuizPopup(max: 20) { max in
        
    } onCancel: {
        
    }

}

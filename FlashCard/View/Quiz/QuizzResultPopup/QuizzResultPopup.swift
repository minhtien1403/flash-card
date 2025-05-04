//
//  QuizzResultPopup.swift
//  FlashCard
//
//  Created by tientm on 03/01/2024.
//

import SwiftUI

struct QuizzResultPopup: View {
    
    private var onFinish: () -> Void
    private var result: (point: Int, total: Int)
    
    init(onFinish: @escaping () -> Void, result: (Int, Int)) {
        self.onFinish = onFinish
        self.result = result
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
                feedbackText
                Text(.resultMessage)
                    .font(.custom(AppFont.mplusBold, size: 20))
                Text("\(result.point) / \(result.total)")
                    .font(.custom(AppFont.mplusBold, size: 20))
                HStack(spacing: 20, content: {
                    Button(action: {
                        onFinish()
                    }, label: {
                        Text(.finish)
                            .font(.custom(AppFont.mplusBold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.red)
                            .clipShape(.rect(cornerRadius: 20))
                    })
                })
            })
        })
    }
    
    private var feedbackText: Text {
        if result.1 == 0 {
            return Text("")
        }
        var textColor: Color
        let result: Double = Double(result.point) / Double(result.total)
        Log.info("Result: \(result)")
        var feedBackText: AppString
        switch result {
        case 0.0 ..< 1.0/3.0:
            feedBackText = .practiceMore
            textColor = .red
        case 1.0:
            feedBackText = .great
            textColor = AppColor.blue
        default:
            textColor = .yellow
            feedBackText = .welldone
        }
        return Text(feedBackText)
            .font(.custom(AppFont.mplusBold, size: 28))
            .foregroundColor(textColor)
    }
}

#Preview {
    QuizzResultPopup(onFinish: {}, result: (5, 5))
}

//
//  CardItem.swift
//  FlashCard
//
//  Created by tientm on 24/12/2023.
//

import SwiftUI
/**
 back +90
 front  +90
 */
struct CardItem: View {
    
    @State private var backDegree = -90.0
    @State private var frontDegree = 0.0
    @State private var isFlipped = false
    @Binding private var card: Card
    private let durationAndDelay : CGFloat = 0.3
    
    init(card: Binding<Card>) {
        self._card = card
    }
    
    var body: some View {
        ZStack(content: {
            CardFront(degree: $frontDegree, content: $card.front)
            CardBack(degree: $backDegree, content: $card.back)
            Button(action: {
                speakOut()
            }, label: {
                VStack(content: {
                    Image(systemName: "speaker.wave.3.fill")
                        .tint(.mint)
                        .font(.title)
                })
            })
            .padding(.top, 80)
            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
            Button(action: {
                speakOut()
            }, label: {
                VStack(content: {
                    Image(systemName: "speaker.wave.3.fill")
                        .tint(.mint)
                        .font(.title)
                })
            })
            .padding(.top, 80)
            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
        })
        .onTapGesture {
            flipCard()
        }
    }
    
    func speakOut() {
        if isFlipped {
            Log.info("Speack: \(card.back)")
            SpeechServices.shared.speakOut(input: card.back)
        } else {
            Log.info("Speack: \(card.front)")
            SpeechServices.shared.speakOut(input: card.front)
        }
    }
    
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
            withAnimation(.linear(duration: durationAndDelay)){
                frontDegree = 90
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
            withAnimation(.linear(duration: durationAndDelay)){
                backDegree = -90
            }
        }
    }
}

#Preview {
    CardItem(card: .constant(Card(deckID: "")))
}

fileprivate struct CardBack: View {
    
    @Binding var degree : Double
    @Binding var content: String
    
    var body: some View {
        ZStack {
            Rectangle()
                 .frame(width: Constant.Screen.width * 0.7,
                        height: Constant.Screen.height * 0.4)
                 .foregroundStyle(.white)
                 .clipShape(.rect(cornerRadius: 20))
                 .shadow(color: .black.opacity(0.5), radius: 20, x: -10, y: 10)
            Text(content)
                .font(.custom(AppFont.mplusBold, size: 20))
                .frame(width: Constant.Screen.width * 0.7)
                .multilineTextAlignment(.center)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

fileprivate struct CardFront: View {
    
    @Binding var degree : Double
    @Binding var content: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.7,
                       height: Constant.Screen.height * 0.4)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: .black.opacity(0.5), radius: 20, x: -10, y: 10)
            Text(content)
                .font(.custom(AppFont.mplusBold, size: 20))
                .frame(width: Constant.Screen.width * 0.7)
                .multilineTextAlignment(.center)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

//
//  QuizView.swift
//  FlashCard
//
//  Created by tientm on 02/01/2024.
//

import SwiftUI

struct QuizzView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @StateObject private var viewModel: QuizzViewModel
    @State private var currentIndex = 0
    @State private var isShowingResultPopup: Bool = false
    @State private var isShowingSubmitPopup: Bool = false
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: QuizzViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView {
            VStack(content: {
                Text(.answerQuizzMessage, "\(viewModel.quizzList[safe: currentIndex]?.quizz ?? "")")
                    .font(.custom(AppFont.mplusBold, size: 24))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                listAnswer
                questionNavigation
                .padding()
                submitButton
            })
            .hideNavigationBarBackButton()
            .navigationTitle(Text(.quizz))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            viewModel.getListCard()
        })
        .popup(isPresented: $isShowingResultPopup) {
            QuizzResultPopup(onFinish: {
                isShowingResultPopup.toggle()
                dismiss()
            }, result: viewModel.calculateQuizzResult())
        }
        .popup(isPresented: $isShowingSubmitPopup) {
            SubmitPopup {
                isShowingSubmitPopup.toggle()
                isShowingResultPopup.toggle()
            } onCancel: {
                isShowingSubmitPopup.toggle()
            }

        }
    }
    
    @ViewBuilder
    private var questionCounter: some View {
        HStack(content: {
            Text("\(currentIndex + 1) / \(viewModel.quizzList.count)")
                .font(.custom(AppFont.mplusBold, size: 28))
        })
    }
    
    @ViewBuilder
    private var listAnswer: some View {
        ForEach(Array(viewModel.quizzList[safe: currentIndex]?.listAnswer.enumerated() ?? [].enumerated()),
                id: \.element) { index, answer in
            Button(action: {
                viewModel.quizzList[currentIndex].selectedAnswer = index
            }, label: {
                Text(answer)
                    .font(.custom(AppFont.mplusBold, size: 18))
                    .foregroundStyle(viewModel.quizzList[currentIndex].selectedAnswer == index  ? .white : .black)
                    .frame(width: Constant.Screen.width - 50,
                           height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2)
                    }
            })
            .background(viewModel.quizzList[currentIndex].selectedAnswer == index ? AppColor.blue : .white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    @ViewBuilder
    private var questionNavigation: some View {
        HStack(content: {
            Button(action: {
                currentIndex -= 1
            }, label: {
                Image(systemName: "arrowtriangle.backward.fill")
                    .font(.custom(AppFont.mplusBold, size: 50))
            })
            .disabled(currentIndex == 0)
            Spacer()
            questionCounter
            Spacer()
            Button(action: {
                currentIndex += 1
            }, label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .font(.custom(AppFont.mplusBold, size: 50))
            })
            .disabled(currentIndex == viewModel.quizzList.count - 1)
        })
    }
    
    @ViewBuilder
    private var submitButton: some View {
        Button(action: {
            isShowingSubmitPopup.toggle()
        }, label: {
            Text("Submit")
                .font(.custom(AppFont.mplusBold, size: 18))
                .foregroundStyle(.white)
                .frame(width: Constant.Screen.width - 50,
                       height: 50)
        })
        .background(AppColor.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15))

    }
}

#Preview {
    NavigationView(content: {
        QuizzView(viewModel: QuizzViewModel(deckID: "", numberOfQuestion: 5))
    })
}

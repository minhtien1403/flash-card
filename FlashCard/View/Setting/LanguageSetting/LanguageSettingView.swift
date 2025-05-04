//
//  LanguageSettingView.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import SwiftUI

struct LanguageSettingView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var localizationServices: LocalizationServices
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        BaseView {
            List(content: {
                HStack(content: {
                    Text(.vietnamese)
                    Spacer()
                    if localizationServices.getCurrentLanguage() == .vietnamese {
                        Image(systemName: "checkmark.circle.fill")
                            .tint(AppColor.blue)
                    }
                })
                .contentShape(Rectangle())
                .onTapGesture {
                    localizationServices.setNewLanguage(.vietnamese)
                }
                HStack(content: {
                    Text(.english)
                    Spacer()
                    if localizationServices.getCurrentLanguage() == .english {
                        Image(systemName: "checkmark.circle.fill")
                            .tint(AppColor.blue)
                    }
                })
                .contentShape(Rectangle())
                .onTapGesture {
                    localizationServices.setNewLanguage(.english)
                }
            })
            .padding(.vertical, 10)
            .background(AppColor.navigationBar)
            .navigationTitle(Text(.language))
        }
    }
}

#Preview {
    NavigationView(content: {
        LanguageSettingView()
    })
}

//
//  BaseView.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

struct BaseView<Content: View>: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .navigationBarTitleDisplayMode(.large)
                .navigationBarLargeTitleItems(trailing: EmptyView().background(AppColor.blue))
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    AppColor.blue,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

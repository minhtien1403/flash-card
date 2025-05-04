//
//  TabbarView.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

struct TabbarView: View {
    
    @StateObject var dashboardNavigator = Navigator()
    @StateObject var settingNavigator = Navigator()
    @StateObject private var viewModel = TabbarViewModel()
    @EnvironmentObject private var localizationServices: LocalizationServices

    
    var body: some View {
        TabView() {
            dashboard
            setting
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    @ViewBuilder
    private var dashboard: some View {
        NavigationStack(path: $dashboardNavigator.navigationPath) {
            DashboardView()
                .navigationDestination(for: Destination.self) { destination in
                    destination.view
                }
        }
        .environmentObject(dashboardNavigator)
        .tabItem {
            VStack(content: {
                Image(systemName: "list.bullet")
                Text(.dashboardTabTitle)
            })
        }
    }
    
    @ViewBuilder
    private var setting: some View {
        NavigationStack(path: $settingNavigator.navigationPath) {
            SettingView()
                .navigationDestination(for: Destination.self) { destination in
                    destination.view
                }
        }
        .environmentObject(settingNavigator)
        .tabItem {
            VStack(content: {
                Image(systemName: "gearshape")
                Text(.settingTabTitle)
            })
        }
    }
}

#Preview {
    TabbarView()
}

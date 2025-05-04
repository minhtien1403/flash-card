//
//  SyncDataView.swift
//  FlashCard
//
//  Created by tientm on 05/01/2024.
//

import SwiftUI

struct SyncDataView: View {
    
    @StateObject private var viewModel = SyncDataViewModel()
    
    var body: some View {
        BaseView {
            switch viewModel.viewState {
            case .checkingIcouldAccountStatus:
                loadingView
            case .loaded, .changeSyncState:
                syncView
            }
        }
        .navigationTitle("Sync")
        .task {
            await viewModel.fetchAccountStatus()
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
            Text(.checkIcloudStatus)
                .font(.custom(AppFont.mplusRegular, size: 16))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var syncView: some View {
        VStack {
            List {
                Section {
                    Toggle(isOn: $viewModel.icloudSync, label: {
                        Text(.syncViaIcloud)
                    })
                    .onChange(of: viewModel.icloudSync, perform: { value in
                        Log.info("Sync: \(value)")
                        viewModel.changeSyncStatus(sync: value)
                    })
                    .disabled(viewModel.accountStatus != .available)
                } footer: {
                    footer
                }
            }
            .overlay {
                if viewModel.viewState == .changeSyncState {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var footer: some View {
        switch viewModel.accountStatus {
        case .couldNotDetermine:
            Text(.couldNotDetermine)
        case .available:
            Text(.available)
        case .restricted:
            Text(.restricted)
        case .noAccount:
            Text(.noAccount)
        case .temporarilyUnavailable:
            Text(.temporarilyUnavailable)
        @unknown default:
            Text(.couldNotDetermine)
        }
    }
}

#Preview {
    NavigationView(content: {
        SyncDataView()
    })
}

//
//  NotificationSettingView.swift
//  PlantingMind
//
//  Created by 최은주 on 4/15/24.
//

import SwiftUI
import Combine

struct NotificationSettingView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var viewModel: NotificationSettingViewModel
    
    var body: some View {
        List {
            notificationOnOff
            
            if viewModel.permission {
                Section {
                    setNotificationTime
                } header: {
                    Text("set_notification_time")
                }
            }
        }
        .navigationTitle("notification_setting")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            viewModel.checkPermission()
        })
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .active {
                viewModel.checkPermission()
            }
        })
    }
    
    var notificationOnOff: some View {
        HStack {
            Text("notification_allow")
            
            Spacer()
            
            ZStack {
                Capsule()
                    .frame(width:50, height:30)
                    .foregroundColor(viewModel.permission ? .green : .gray.opacity(0.8))
                ZStack{
                    Circle()
                        .frame(width:26)
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                .offset(x:viewModel.permission ? 10 : -10)
                .animation(.spring, value: viewModel.permission)
            }
            .onTapGesture {
                if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    var setNotificationTime: some View {
        HStack {
            Text("set_time_picker")
            DatePicker("", selection: $viewModel.pickedTime, displayedComponents: [.hourAndMinute])
        }
    }
}

#Preview {
    NotificationSettingView(viewModel: NotificationSettingViewModel(notificationManager: NotificationManager()))
}

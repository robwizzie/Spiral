//
//  HomeView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var screenTimeMonitor = ScreenTimeMonitor()
    @State private var showingIntervention = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // App title
                    Text("SPIRAL")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("ElectricBlue"))

                    // Placeholder spiral animation
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color("ElectricBlue"), Color("NeonPurple")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .overlay(
                            Text("🌀")
                                .font(.system(size: 60))
                        )

                    // Status card
                    VStack(spacing: 12) {
                        Text("Screen Time Status")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(screenTimeMonitor.authorizationStatusString)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(
                                screenTimeMonitor.authorizationStatus == .approved
                                    ? Color("SuccessGreen")
                                    : Color("WarningOrange")
                            )

                        if screenTimeMonitor.authorizationStatus != .approved {
                            Button("Request Permission") {
                                Task {
                                    try? await screenTimeMonitor.requestAuthorization()
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        } else {
                            HStack {
                                Image(systemName: screenTimeMonitor.isMonitoring ? "eye.fill" : "eye.slash.fill")
                                Text(screenTimeMonitor.isMonitoring ? "Monitoring Active" : "Monitoring Inactive")
                            }
                            .foregroundColor(.white.opacity(0.8))

                            if !screenTimeMonitor.isMonitoring {
                                Button("Start Monitoring") {
                                    screenTimeMonitor.startMonitoring()
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            } else {
                                Button("Stop Monitoring") {
                                    screenTimeMonitor.stopMonitoring()
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                        }
                    }
                    .padding(20)
                    .background(Color("DeepPurple"))
                    .cornerRadius(16)

                    // Test intervention button
                    Button("Test Intervention View") {
                        showingIntervention = true
                    }
                    .buttonStyle(SecondaryButtonStyle())

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Settings (Coming Soon)")) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color("ElectricBlue"))
                    }
                }
            }
        }
        .sheet(isPresented: $showingIntervention) {
            InterventionView(
                viewModel: InterventionViewModel(
                    mode: .accountability,
                    duration: 1680, // 28 minutes
                    interventionsToday: 2,
                    dismissalsToday: 1,
                    onDismiss: {
                        showingIntervention = false
                    }
                )
            )
        }
        .onAppear {
            screenTimeMonitor.checkAuthorizationStatus()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [AppSettings.self, ScrollSession.self, UserStats.self], inMemory: true)
}

//
//  ContentView.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingMainApp = false
    
    var body: some View {
        ZStack {
            // Dark background with subtle gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppTheme.background,
                    Color(hex: "151515")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if isShowingMainApp {
                MainTabView()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            } else {
                // Launch Screen
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title with glow effect
                    Text("SAIYAN TRAINING")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(AppTheme.primary)
                        .shadow(color: AppTheme.primary.opacity(0.8), radius: 10, x: 0, y: 0)
                    
                    // Dragon Ball themed image with energy effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        AppTheme.accent.opacity(0.7),
                                        AppTheme.accent.opacity(0)
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 150, height: 150)
                            .blur(radius: 20)
                        
                        // Middle glow
                        Circle()
                            .fill(AppTheme.accent.opacity(0.4))
                            .frame(width: 120, height: 120)
                        
                        // Icon
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .foregroundColor(AppTheme.accent)
                            .shadow(color: AppTheme.accent.opacity(0.8), radius: 5)
                    }
                    .padding()
                    
                    // Subtitle
                    Text("Unleash Your Inner Power")
                        .font(.title2)
                        .foregroundColor(AppTheme.secondaryText)
                        .padding(.bottom, 40)
                    
                    // Start button with pulse animation
                    Button(action: {
                        withAnimation {
                            isShowingMainApp = true
                        }
                    }) {
                        Text("START TRAINING")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppTheme.primary,
                                        AppTheme.primary.opacity(0.8)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: AppTheme.primary.opacity(0.4), radius: 10, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppTheme.primary.opacity(0.6), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 40)
                    .buttonStyle(PulseButtonStyle())
                    
                    Spacer()
                    
                    // App tagline
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(AppTheme.primary)
                        
                        Text("Power up with every workout")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.bottom)
                }
                .padding()
                .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
}

// Custom button style with pulse animation
struct PulseButtonStyle: ButtonStyle {
    @State private var isPulsing = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .shadow(
                color: AppTheme.primary.opacity(isPulsing ? 0.6 : 0.2),
                radius: isPulsing ? 15 : 5,
                x: 0,
                y: 0
            )
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
    }
}

#Preview {
    ContentView()
}

//
//  Theme.swift
//  SaiyanTrainingApp
//
//  Created on 4/13/25.
//

import SwiftUI

// Custom color scheme for the app
struct AppTheme {
    // Primary colors
    static let primary = Color(hex: "FF9500")       // Vibrant orange
    static let secondary = Color(hex: "007AFF")     // Bright blue
    static let accent = Color(hex: "FFD700")        // Gold for power-related elements
    
    // Background colors
    static let background = Color(hex: "0A0A0A")    // Deep dark background
    static let cardBackground = Color(hex: "1C1C1E").opacity(0.9) // Dark card background
    static let secondaryBackground = Color(hex: "2C2C2E").opacity(0.8) // Secondary dark background
    
    // Text colors
    static let text = Color.white
    static let secondaryText = Color.gray
    
    // Accent/Status colors
    static let powerGain = Color(hex: "4CD964")     // Green for power gains
    static let energy = Color(hex: "5AC8FA")        // Blue for energy
    static let warning = Color(hex: "FF3B30")       // Red for warnings
    
    // Transformation colors
    static let baseForm = Color(hex: "007AFF")          // Base form blue
    static let superSaiyan = Color(hex: "FFD700")       // Super Saiyan yellow/gold
    static let superSaiyan2 = Color(hex: "FFA700")      // Super Saiyan 2 deeper gold
    static let superSaiyan3 = Color(hex: "FF9500")      // Super Saiyan 3 orange
    static let superSaiyanGod = Color(hex: "FF2D55")    // Super Saiyan God red
    
    // Transformation gradient for backgrounds
    static func transformationGradient(for transformation: String) -> LinearGradient {
        switch transformation {
        case "Base Form":
            return LinearGradient(
                gradient: Gradient(colors: [baseForm.opacity(0.7), baseForm.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case "Super Saiyan":
            return LinearGradient(
                gradient: Gradient(colors: [superSaiyan.opacity(0.7), superSaiyan.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case "Super Saiyan 2":
            return LinearGradient(
                gradient: Gradient(colors: [superSaiyan2.opacity(0.7), superSaiyan2.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case "Super Saiyan 3":
            return LinearGradient(
                gradient: Gradient(colors: [superSaiyan3.opacity(0.7), superSaiyan3.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case "Super Saiyan God":
            return LinearGradient(
                gradient: Gradient(colors: [superSaiyanGod.opacity(0.7), superSaiyanGod.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [baseForm.opacity(0.7), baseForm.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // Button styles
    static let primaryButton = Color(hex: "FF9500")
    static let secondaryButton = Color(hex: "3A3A3C")
    
    // Card styles
    static let cardShadowColor = Color.black.opacity(0.5)
    static let cardShadowRadius: CGFloat = 5
    static let cardCornerRadius: CGFloat = 15
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Custom ViewModifiers for consistent styling
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cardCornerRadius)
            .shadow(color: AppTheme.cardShadowColor, radius: AppTheme.cardShadowRadius)
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.primaryButton)
            .cornerRadius(10)
            .shadow(color: AppTheme.primaryButton.opacity(0.5), radius: 5, x: 0, y: 2)
    }
}

// Extension for easy styling
extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
    
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}

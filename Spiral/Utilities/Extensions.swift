//
//  Extensions.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    // Primary Colors
    static let deepPurple = Color(hex: "1A0B2E")
    static let electricBlue = Color(hex: "00D9FF")
    static let neonPurple = Color(hex: "7B2CBF")

    // Alert Colors
    static let warningOrange = Color(hex: "FF6B35")
    static let alertRed = Color(hex: "E63946")

    // Success
    static let successGreen = Color(hex: "10B981")

    // Neutral
    static let pureBlack = Color(hex: "000000")
    static let pureWhite = Color(hex: "FFFFFF")
    static let softGray = Color(hex: "F8F9FA")

    // Convenience initializer for hex colors
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - TimeInterval Extensions

extension TimeInterval {
    /// Format duration as "Xh Ym" or "Xm"
    var formatted: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    /// Format duration as "X minutes" or "X hours Y minutes"
    var formattedLong: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60

        if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") \(minutes) minute\(minutes == 1 ? "" : "s")"
        } else {
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        }
    }
}

// MARK: - Date Extensions

extension Date {
    /// Check if date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Check if date is in the same week as today
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// Start of day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// End of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
}

// MARK: - View Extensions

extension View {
    /// Apply card style
    func cardStyle() -> some View {
        self
            .padding(20)
            .background(Color.deepPurple)
            .cornerRadius(AppConstants.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 2)
    }
}

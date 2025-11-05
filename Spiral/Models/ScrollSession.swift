//
//  ScrollSession.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation
import SwiftData

@Model
class ScrollSession {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var appName: String
    var duration: TimeInterval
    var scrollEvents: Int
    var interactions: Int
    var appSwitches: Int
    var averageScrollVelocity: Double
    var wasInterrupted: Bool
    var wasIgnored: Bool
    var userResponse: ResponseType?
    var userNote: String?
    var roastMessage: String?
    var interventionMode: InterventionMode

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        appName: String,
        duration: TimeInterval = 0,
        scrollEvents: Int = 0,
        interactions: Int = 0,
        appSwitches: Int = 0,
        averageScrollVelocity: Double = 0,
        wasInterrupted: Bool = false,
        wasIgnored: Bool = false,
        userResponse: ResponseType? = nil,
        userNote: String? = nil,
        roastMessage: String? = nil,
        interventionMode: InterventionMode = .gentle
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.appName = appName
        self.duration = duration
        self.scrollEvents = scrollEvents
        self.interactions = interactions
        self.appSwitches = appSwitches
        self.averageScrollVelocity = averageScrollVelocity
        self.wasInterrupted = wasInterrupted
        self.wasIgnored = wasIgnored
        self.userResponse = userResponse
        self.userNote = userNote
        self.roastMessage = roastMessage
        self.interventionMode = interventionMode
    }

    /// Determines if this session qualifies as active doom scrolling
    var isActiveDoomScrolling: Bool {
        let interactionRatio = Double(interactions) / max(Double(scrollEvents), 1.0)
        return interactionRatio < AppConstants.interactionRatioThreshold
            && averageScrollVelocity > AppConstants.minScrollVelocityThreshold
    }
}

// MARK: - Response Type

enum ResponseType: String, Codable {
    case worthIt
    case waste
    case justBreak
    case dismissed

    var displayName: String {
        switch self {
        case .worthIt: return "Worth it - saw good stuff ✓"
        case .waste: return "Total waste - help me stop 🛑"
        case .justBreak: return "Just taking a break 😌"
        case .dismissed: return "Dismissed"
        }
    }
}

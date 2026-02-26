import SwiftUI

struct Quest: Identifiable {
    let id: String
    let title: String
    let icon: String
    let totalRequired: Int
    let starReward: Int
    
    var progress: Int = 0
    var lastClaimDate: Date? = nil
    var wasClaimedToday: Bool = false
    
    var isCompleted: Bool {
        progress >= totalRequired
    }
    
    var isOnCooldown: Bool {
        guard let lastClaimDate else { return false }
        return Date() < lastClaimDate.addingTimeInterval(12 * 60 * 60)
    }
    
    var remainingCooldown: TimeInterval {
        guard let lastClaimDate else { return 0 }
        let endDate = lastClaimDate.addingTimeInterval(12 * 60 * 60)
        return max(endDate.timeIntervalSinceNow, 0)
    }
}


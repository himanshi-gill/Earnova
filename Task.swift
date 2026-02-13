import SwiftUI

enum TaskType: String, Codable {
    case reward
    case penalty
}

struct Task: Identifiable, Codable{
    let id: UUID
    let title: String
    let avatarImage: String
    let type: TaskType
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var createdAt: Date 
}

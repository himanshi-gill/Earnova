import Foundation

struct UserDefaultsManager {
    
    static let coinsKey = "coinsCollected"
    static let starsKey = "starsCollected"
    static let goalKey = "coinGoal"
    static let avatarKey = "selectedAvatarImage"
    static let tasksKey = "tasks"
    static let unlockedAvatarsKey = "unlockedAvatars"
    static let userNameKey = "userName"
    
    // MARK: - Save
    static func saveTasks(_ tasks: [Task]) {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
    
    // MARK: - Load
    static func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let tasks = try? JSONDecoder().decode([Task].self, from: data)
        else {
            return []
        }
        return tasks
    }
    
    // MARK: - Save Unlocked Avatars
    static func saveUnlockedAvatars(_ avatars: Set<String>) {
        let array = Array(avatars)
        UserDefaults.standard.set(array, forKey: unlockedAvatarsKey)
    }

    // MARK: - Load Unlocked Avatars
    static func loadUnlockedAvatars() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: unlockedAvatarsKey) ?? []
        return Set(array)
    }
}

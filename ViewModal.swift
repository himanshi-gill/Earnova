import SwiftUI
import Combine
import Foundation

final class AppState: ObservableObject {

    @Published var coinsCollected: Int {
        didSet {
            UserDefaults.standard.set(coinsCollected, forKey: UserDefaultsManager.coinsKey)
        }
    }

    @Published var starsCollected: Int {
        didSet {
            UserDefaults.standard.set(starsCollected, forKey: UserDefaultsManager.starsKey)
        }
    }

    @Published var coinGoal: Int {
        didSet {
            UserDefaults.standard.set(coinGoal, forKey: UserDefaultsManager.goalKey)
        }
    }

    @Published var selectedAvatarImage: String {
        didSet {
            UserDefaults.standard.set(selectedAvatarImage, forKey: UserDefaultsManager.avatarKey)
        }
    }

    @Published var tasks: [Task] {
        didSet {
            UserDefaultsManager.saveTasks(tasks)
        }
    }
    @Published var unlockedAvatars: Set<String> {
        didSet {
            UserDefaultsManager.saveUnlockedAvatars(unlockedAvatars)
        }
    }
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: UserDefaultsManager.userNameKey)
        }
    }
    
    func completeGoalAndReset() {
        coinsCollected -= coinGoal
        
        tasks.removeAll()
    }

    init() {
        self.coinsCollected = UserDefaults.standard.integer(forKey: UserDefaultsManager.coinsKey)
        self.starsCollected = UserDefaults.standard.integer(forKey: UserDefaultsManager.starsKey)
        self.coinGoal = UserDefaults.standard.integer(forKey: UserDefaultsManager.goalKey)
        self.selectedAvatarImage =
            UserDefaults.standard.string(forKey: UserDefaultsManager.avatarKey) ?? "animal1"
        self.tasks = UserDefaultsManager.loadTasks()
        self.unlockedAvatars = UserDefaultsManager.loadUnlockedAvatars()
        self.userName =
            UserDefaults.standard.string(forKey: UserDefaultsManager.userNameKey) ?? ""
    }
}

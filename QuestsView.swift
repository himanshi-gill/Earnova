import SwiftUI
import UIKit

struct QuestsView: View {
    
    @Binding var starsCollected: Int
    @Binding var coinsCollected: Int
    
    @State private var quests: [Quest] = [
        Quest(id: "drink_water", title: "Drink Water", icon: "drop.fill", totalRequired: 3, starReward: 3),
        Quest(id: "help_at_home", title: "Help at Home", icon: "house.fill", totalRequired: 3, starReward: 3),
        Quest(id: "say_something_kind", title: "Say Something Kind", icon: "heart.fill", totalRequired: 3, starReward: 3),
        Quest(id: "clean_your_toys", title: "Clean Your Toys", icon: "sparkles", totalRequired: 1, starReward: 3),
        Quest(id: "brush_teeth", title: "Brush Your Teeth", icon: "mouth.fill", totalRequired: 2, starReward: 3),
        Quest(id: "throw_trash", title: "Throw Trash in the Bin", icon: "trash.fill", totalRequired: 3, starReward: 3),
        Quest(id: "pack_school_bag", title: "Pack Your School Bag", icon: "backpack.fill", totalRequired: 1, starReward: 3),
    ]
    
    @State private var lastDailyRewardDate: Date? = UserDefaults.standard.object(forKey: "dailyRewardDate") as? Date
    
    var allQuestsClaimed: Bool {
        quests.allSatisfy { $0.wasClaimedToday }
    }

    var hasClaimedToday: Bool {
        guard let lastDate = lastDailyRewardDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    var body: some View {
        VStack ( spacing: 0){
            
            Text("Quests")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    ForEach($quests) { $quest in
                        QuestCard(
                            quest: $quest,
                            starsCollected: $starsCollected
                        )
                    }
                    
                    Spacer(minLength: 120) // space for streak section
                }
                .padding()
            }
            
            // 🌟 STREAK SECTION (Fixed Bottom)
            VStack(spacing: 10) {

                Text("Daily Completion Reward")
                    .foregroundColor(.white)
                    .font(.headline)

                if allQuestsClaimed && !hasClaimedToday {

                    Button("Claim 10 Coins 🪙") {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

                        coinsCollected += 10
                        let now = Date()
                        lastDailyRewardDate = now
                        UserDefaults.standard.set(now, forKey: "dailyRewardDate")

                        // Reset quests for next day
                        for index in quests.indices {
                            quests[index].wasClaimedToday = false
                        }
                    }
                    .buttonStyle(StreakButtonStyle())

                } else if hasClaimedToday {

                    Text("Come back tomorrow.")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                        .font(.subheadline.weight(.semibold))
                } else {

                    Text("Complete all quests today to earn 10 coins!")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                }

            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#F07B0F"), Color(hex: "#D1A75C")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .padding()
        }
    }
}

struct QuestCard: View {
    
    @Binding var quest: Quest
    @Binding var starsCollected: Int
    
    func timeString(from interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            
            // LEFT SIDE (Icon + Title + Progress)
            VStack(alignment: .leading, spacing: 5) {
                
                HStack {
                    Image(systemName: quest.icon)
                        .foregroundColor(Color(hex: "#F07B0F"))
                        .font(.title2)
                    
                    Text(quest.title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                ProgressView(value: Double(quest.progress),
                             total: Double(quest.totalRequired))
                    .tint(Color(hex: "#F07B0F"))
                    .frame(maxWidth: .infinity)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // RIGHT SIDE (Tall Button)
            VStack(spacing: 8) {
                
                // COUNTER TEXT
                Text("\(quest.progress)/\(quest.totalRequired)")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "#F07B0F"))
                
                HStack(spacing: 16) {
                    
                    // MINUS BUTTON
                    Button {
                        if quest.progress > 0 {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            quest.progress -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.headline.bold())
                            .frame(width: 28, height: 28)
                    }
                    .disabled(quest.progress == 0)
                    
                    if quest.isOnCooldown {

                        CooldownRingView(remainingTime: quest.remainingCooldown)

                    } else if quest.isCompleted {

                        Button("Claim ⭐") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            starsCollected += quest.starReward
                            quest.progress = 0
                            quest.lastClaimDate = Date()
                            quest.wasClaimedToday = true
                            UserDefaults.standard.set(Date(), forKey: "cooldown_\(quest.id)")
                        }
                        .font(.caption.bold())
                        
                    } else {
                        
                        // PLUS BUTTON
                        Button {
                            if quest.progress < quest.totalRequired {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                quest.progress += 1
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline.bold())
                                .frame(width: 28, height: 28)
                        }
                        .disabled(quest.progress == quest.totalRequired)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color(hex: "#F07B0F"))
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .frame(width: 110)
            .animation(.easeInOut(duration: 0.2), value: quest.progress)
            .animation(.easeInOut(duration: 0.2), value: quest.progress)
            .onAppear {
                if let savedDate = UserDefaults.standard.object(forKey: "cooldown_\(quest.id)") as? Date {
                    quest.lastClaimDate = savedDate
                }
            }
        }
        .padding()
        .background(Color(hex: "#0B2E52").opacity(0.9))
        .cornerRadius(18)
    }
}

struct CooldownRingView: View {
    
    var remainingTime: TimeInterval
    let totalTime: TimeInterval = 12 * 60 * 60
    
    var progress: Double {
        remainingTime / totalTime
    }
    
    var body: some View {
        ZStack {
            
            // Background Circle
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 5)
            
            // Progress Ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
            
            // Clock icon in center
            Image(systemName: "clock.fill")
                .font(.system(size: 20, weight: .bold))
        }
        .frame(width: 32, height: 32)
    }
}

struct QuestButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.bold())
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#F07B0F"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct StreakButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.bold())
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct VerticalQuestButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.bold())
            .multilineTextAlignment(.center)
            .frame(width: 90, height: 80) // controls button size
            .background(Color(hex: "#F07B0F"))
            .foregroundColor(.white)
            .cornerRadius(14)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

//#Preview {
//    QuestsView(coinsCollected: .constant(0), starsCollected: .constant(0))
//}

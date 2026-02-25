import SwiftUI

struct QuestsView: View {
    
    @Binding var starsCollected: Int
    @Binding var coinsCollected: Int
    
    @State private var quests: [Quest] = [
        Quest(title: "Drink Water 💧", icon: "drop.fill", totalRequired: 3, starReward: 5),
        Quest(title: "Help at Home 🤝", icon: "house.fill", totalRequired: 1, starReward: 8),
        Quest(title: "Say Something Kind 😊", icon: "heart.fill", totalRequired: 2, starReward: 6),
        Quest(title: "Clean Your Toys 🧸", icon: "sparkles", totalRequired: 1, starReward: 7)
    ]
    
    @State private var streak = StreakQuest(
        title: "Kindness Streak 🌈",
        daysRequired: 5,
        coinReward: 40
    )
    
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
            StreakCard(
                streak: $streak,
                coinsCollected: $coinsCollected
            )
            .padding()
        }
    }
}

struct QuestCard: View {
    
    @Binding var quest: Quest
    @Binding var starsCollected: Int
    
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
                            quest.progress -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.headline.bold())
                            .frame(width: 28, height: 28)
                    }
                    .disabled(quest.progress == 0)
                    
                    if quest.isCompleted {
                        
                        // CLAIM BUTTON
                        Button("Claim ⭐") {
                            starsCollected += quest.starReward
                            quest.progress = 0
                        }
                        .font(.caption.bold())
                        
                    } else {
                        
                        // PLUS BUTTON
                        Button {
                            if quest.progress < quest.totalRequired {
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
        }
        .padding()
        .background(Color(hex: "#0B2E52").opacity(0.9))
        .cornerRadius(18)
    }
}


struct StreakCard: View {
    
    @Binding var streak: StreakQuest
    @Binding var coinsCollected: Int
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Weekly Streak")
                .foregroundColor(.white)
                .font(.headline)
            
            Text(streak.title)
                .foregroundColor(.white)
            
            ProgressView(value: Double(streak.currentDays), total: Double(streak.daysRequired))
                .tint(Color(hex: "#D1A75C"))
            
            Text("\(streak.currentDays)/\(streak.daysRequired) Days")
                .foregroundColor(.white.opacity(0.8))
                .font(.caption)
            
            if streak.isCompleted {
                Button("Claim 🪙 \(streak.coinReward)") {
                    coinsCollected += streak.coinReward
                    streak.currentDays = 0
                }
                .buttonStyle(StreakButtonStyle())
            } else {
                Button("I did it today!") {
                    if streak.currentDays < streak.daysRequired {
                        streak.currentDays += 1
                    }
                }
                .buttonStyle(StreakButtonStyle())
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

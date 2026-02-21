import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    enum Tab {
        case map, quests, create, shop, profile
    }
    
    @State private var selectedTab: Tab = .map
    @State private var confettiCounter = 0
    @State private var isCelebrating = false

    var body: some View {
        ZStack {
            backgroundForTab()

            VStack {
                Spacer()
                currentTabView()
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .onChange(of: appState.coinsCollected) { newValue in
            if newValue >= appState.coinGoal && !isCelebrating {
                startConfetti()
            }
        }
        .onChange(of: appState.coinGoal) { _ in
            isCelebrating = false
        }
        .confettiCannon(
            trigger: $confettiCounter,
            num: 80,
            radius: 500
        )
    }

    @ViewBuilder
    private func backgroundForTab() -> some View {
        switch selectedTab {
        case .map:
            Image("it")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // ONLY the background ignores safe area

        default:
            LinearGradient(
                colors: [
                    Color(hex: "#061732"),
                    Color(hex: "#0E3867"),
                    Color(hex: "#5E677A")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
    private func startConfetti() {
        isCelebrating = true
        confettiCounter += 1

        let endTime = Date().addingTimeInterval(30)

        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            if Date() < endTime {
                confettiCounter += 1
            } else {
                timer.invalidate()
                isCelebrating = false
                
                // 🔥 RESET APP STATE HERE
                appState.completeGoalAndReset()
            }
        }
    }

    


    // ✅ FUNCTION GOES HERE (outside body)
    @ViewBuilder
    private func currentTabView() -> some View {
        switch selectedTab {
        case .map:
            MapView(
                coinsCollected: $appState.coinsCollected,
                starsCollected: $appState.starsCollected,
                tasks: $appState.tasks
            )


        case .quests:
            QuestsView(
                starsCollected: $appState.starsCollected,
                coinsCollected: $appState.coinsCollected
            )


        case .create:
            CreateStoryView(
                coinsCollected: $appState.coinsCollected,
                tasks: $appState.tasks,
                selectedAvatarImage: $appState.selectedAvatarImage
            )


        case .shop:
            ShopView(
                selectedAvatarImage: $appState.selectedAvatarImage,
                starsCollected: $appState.starsCollected
            )


        case .profile:
            ProfileView(
                userName: $appState.userName,
                selectedAvatarImage: $appState.selectedAvatarImage,
                coinGoal: $appState.coinGoal,
                coinsCollected: $appState.coinsCollected,
                starsCollected: $appState.starsCollected
            )
        }
    }
}

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    enum Tab {
        case map, quests, create, shop, profile
    }
    
    @State private var selectedTab: Tab = .map
    

    var body: some View {
        ZStack {
            // Background layer (does NOT affect layout)
            backgroundForTab()

            // Foreground content (layout stays same)
            VStack {
                Spacer()
                currentTabView()
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
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

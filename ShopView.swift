import SwiftUI

struct ShopView: View {
    
    @Binding var selectedAvatarImage: String
    @Binding var starsCollected: Int
    @EnvironmentObject var appState: AppState
    @State private var showingPurchaseConfirmation = false
    @State private var pendingItemName = ""
    @State private var pendingStarCost = 0
    @State private var pendingImageName = ""
    
    // MARK: - Data Model for animal and avatar
    struct Animal: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let starCost: Int
    }
    
    struct AvatarItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let starCost: Int
    }
    
    // MARK: - Animal List
    let animals: [Animal] = [
        Animal(name: "Brave Cub", imageName: "animal1", starCost: 0),
        Animal(name: "Misty Fox", imageName: "animal2", starCost: 20),
        Animal(name: "Sunny Pup", imageName: "animal3", starCost: 30),
        Animal(name: "Forest Deer", imageName: "animal4", starCost: 40),
        Animal(name: "Snow Bunny", imageName: "animal5", starCost: 50),
        Animal(name: "Night Owl", imageName: "animal6", starCost: 60)
    ]
    
    // MARK: - Mascot List
    let mascots: [AvatarItem] = [
        AvatarItem(name: "Star Buddy", imageName: "ma1", starCost: 40),
        AvatarItem(name: "Moon Pal", imageName: "ma2", starCost: 50),
        AvatarItem(name: "Cloud Friend", imageName: "ma3", starCost: 60),
        AvatarItem(name: "Dream Sprite", imageName: "ma4", starCost: 70)
    ]
    
    //    @State private var selectedAnimal: Animal? = nil
    var body: some View {
        ZStack {

            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("My Collection")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // Selected Avatar
                    VStack(spacing: 10) {
                        Image(selectedAvatarImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hex: "#F07B0F"), lineWidth: 4))
                            .shadow(radius: 8)
                        
                        Text(animals.first(where: { $0.imageName == selectedAvatarImage })?.name ?? "Avatar")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#0B2E52").opacity(0.9))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Stars Balance
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "#D1A75C"))
                        Text("Stars: \(starsCollected)")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    // Animals Grid
                    HStack {
                        Text("Animals")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(animals) { animal in
                            AnimalCard(
                                animal: animal,
                                isSelected: animal.imageName == selectedAvatarImage,
                                starsCollected: $starsCollected,
                                selectedAvatarImage: $selectedAvatarImage,
                                unlockedAvatars: $appState.unlockedAvatars
                            ){ name, cost, image in
                                pendingItemName = name
                                pendingStarCost = cost
                                pendingImageName = image
                                showingPurchaseConfirmation = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Mascots Grid
                    HStack {
                        Text("Mascots")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing:16) {
                        ForEach(mascots) { mascot in
                            MascotCard(
                                mascot: mascot,
                                starsCollected: $starsCollected,
                                selectedAvatarImage: $selectedAvatarImage,
                                unlockedAvatars: $appState.unlockedAvatars
                            ){ name, cost, image in
                                pendingItemName = name
                                pendingStarCost = cost
                                pendingImageName = image
                                showingPurchaseConfirmation = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // ✅ popup MUST be inside same ZStack
            if showingPurchaseConfirmation {

                Color.black.opacity(0.45)
                    .ignoresSafeArea()

                ConfirmationDialogView(
                    itemName: pendingItemName,
                    starCost: pendingStarCost,
                    onConfirm: {
                        if starsCollected >= pendingStarCost {
                            starsCollected -= pendingStarCost
                            appState.unlockedAvatars.insert(pendingImageName)
                            selectedAvatarImage = pendingImageName
                        }
                        showingPurchaseConfirmation = false
                    },
                    onCancel: {
                        showingPurchaseConfirmation = false
                    }
                )
            }
        }
    }
    
    struct AnimalCard: View {
        let animal: ShopView.Animal
        let isSelected: Bool
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
//        @State private var showingPurchaseConfirmation = false
        
        var body: some View {
            Button {
                if unlockedAvatars.contains(animal.imageName) || animal.starCost == 0 {
                    selectedAvatarImage = animal.imageName
                } else {
                    if starsCollected >= animal.starCost {
                        requestPurchase(animal.name, animal.starCost, animal.imageName)
                    }
                }
            } label: {
                VStack(spacing: 6) {
                    
                    ZStack {
                        Image(animal.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .opacity((unlockedAvatars.contains(animal.imageName) || animal.starCost == 0) ? 1.0 : 0.5)

                        if !(unlockedAvatars.contains(animal.imageName) || animal.starCost == 0) {
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(0.45))

                                Text("⭐ \(animal.starCost)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(1))
                            }
                        }
                    }
                    
                    Text(animal.name)
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color(hex: "#0B2E52").opacity(0.85))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color(hex: "#F07B0F") : Color.clear, lineWidth: 2)
                )
            }
        }
    }
    struct MascotCard: View {
        let mascot: ShopView.AvatarItem
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
        
//        @State private var showingPurchaseConfirmation = false
        
        var body: some View {
            Button {
                if unlockedAvatars.contains(mascot.imageName) {
                    selectedAvatarImage = mascot.imageName
                } else {
                    if starsCollected >= mascot.starCost {
                        requestPurchase(mascot.name, mascot.starCost, mascot.imageName)
                    }
                }
            } label: {
                VStack(spacing: 6) {
                    
                    ZStack {
                        Image(mascot.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .opacity((unlockedAvatars.contains(mascot.imageName) || mascot.starCost == 0) ? 1.0 : 0.5)

                        if !(unlockedAvatars.contains(mascot.imageName) || mascot.starCost == 0) {
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(0.45))

                                Text("⭐ \(mascot.starCost)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(1))
                            }
                        }
                    }
                    
                    Text(mascot.name)
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color(hex: "#0B2E52").opacity(0.85))
                .cornerRadius(14)
            }
        }
    }
}
            
    
//    #Preview {
//        ShopView(
//            selectedAvatarImage: .constant("animal1"),
//            starsCollected: .constant(120)
//        )
//    }

import SwiftUI
import UIKit

struct ShopView: View {
    
    @Binding var selectedAvatarImage: String
    @Binding var starsCollected: Int
    @EnvironmentObject var appState: AppState
    @State private var showingPurchaseConfirmation = false
    @State private var pendingItemName = ""
    @State private var pendingStarCost = 0
    @State private var pendingImageName = ""
    
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
    
    struct MysticItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let starCost: Int
    }
    
    struct MagicItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let starCost: Int
    }
    
    struct SuperheroItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let starCost: Int
    }
    
    let animals: [Animal] = [
        Animal(name: "Brave Cub", imageName: "animal1", starCost: 0),
        Animal(name: "Chubby Rabbit", imageName: "animal2", starCost: 10),
        Animal(name: "Cosmo Panda", imageName: "animal3", starCost: 20),
        Animal(name: "Tiny Dino", imageName: "animal4", starCost: 20),
        Animal(name: "Starlight Jumbo", imageName: "animal5", starCost: 30),
        Animal(name: "Star Monkey", imageName: "animal6", starCost: 30)
    ]
    
    let mascots: [AvatarItem] = [
        AvatarItem(name: "Galaxy Gloop", imageName: "ma1", starCost: 30),
        AvatarItem(name: "Moon Pal", imageName: "ma2", starCost: 30),
        AvatarItem(name: "Wishy Star", imageName: "ma3", starCost: 30),
        AvatarItem(name: "Cloud Friend", imageName: "ma4", starCost: 30)
    ]
    
    let magics: [MagicItem] = [
        MagicItem(name: "Lumi Flutter", imageName: "magic1", starCost: 55),
        MagicItem(name: "Nebula Snuggle", imageName: "magic2", starCost: 85),
        MagicItem(name: "Star Sentinel", imageName: "magic3", starCost: 95),
        MagicItem(name: "Astro Spark", imageName: "magic4", starCost: 105),
        MagicItem(name: "Glow Chef", imageName: "magic5", starCost: 165)
    ]
    
    let mystics: [MysticItem] = [
        MysticItem(name: "Flarefeather", imageName: "y1", starCost: 180),
        MysticItem(name: "Monster", imageName: "y2", starCost: 190),
        MysticItem(name: "Moon Guardian", imageName: "y3", starCost: 100),
        MysticItem(name: "Draco", imageName: "y4", starCost: 110),
        MysticItem(name: "Starfeather sage", imageName: "y5", starCost: 120),
        MysticItem(name: "Lumina Fang", imageName: "y6", starCost: 130),
        MysticItem(name: "Phoenix", imageName: "y7", starCost: 140)
    ]
    
    let superheroes: [SuperheroItem] = [
        SuperheroItem(name: "Inferno Cadet", imageName: "sh1", starCost: 270),
        SuperheroItem(name: "Storm Sentinel", imageName: "sh2", starCost: 280),
        SuperheroItem(name: "Thunder Maestro", imageName: "sh3", starCost: 290),
        SuperheroItem(name: "Volt Ranger", imageName: "sh4", starCost: 300),
        SuperheroItem(name: "Emerald Bloom", imageName: "sh5", starCost: 300),
        SuperheroItem(name: "Frost Nova", imageName: "sh6", starCost: 320),
        SuperheroItem(name: "Cosmic Vanguard", imageName: "sh7", starCost: 230)
    ]
    
    var selectedAvatarName: String {
        animals.first(where: { $0.imageName == selectedAvatarImage })?.name ??
        mascots.first(where: { $0.imageName == selectedAvatarImage })?.name ??
        magics.first(where: { $0.imageName == selectedAvatarImage })?.name ??
        mystics.first(where: { $0.imageName == selectedAvatarImage })?.name ??
        superheroes.first(where: { $0.imageName == selectedAvatarImage })?.name ??
        "Avatar"
    }
    
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
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
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hex: "#F07B0F"), lineWidth: 4))
                            .shadow(radius: 10)
                        Text(selectedAvatarName)
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
                                isSelected: mascot.imageName == selectedAvatarImage,
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

                    // Magic Grid
                    HStack {
                        Text("Magical")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(magics) { magic in
                            MagicCard(
                                magic: magic,
                                isSelected: magic.imageName == selectedAvatarImage,
                                starsCollected: $starsCollected,
                                selectedAvatarImage: $selectedAvatarImage,
                                unlockedAvatars: $appState.unlockedAvatars
                            ) { name, cost, image in
                                pendingItemName = name
                                pendingStarCost = cost
                                pendingImageName = image
                                showingPurchaseConfirmation = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Mystic Grid
                    HStack {
                        Text("Mystics")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(mystics) { mystic in
                            MysticCard(
                                mystic: mystic,
                                isSelected: mystic.imageName == selectedAvatarImage,
                                starsCollected: $starsCollected,
                                selectedAvatarImage: $selectedAvatarImage,
                                unlockedAvatars: $appState.unlockedAvatars
                            ) { name, cost, image in
                                pendingItemName = name
                                pendingStarCost = cost
                                pendingImageName = image
                                showingPurchaseConfirmation = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Superheroes Grid
                    HStack {
                        Text("Superheroes")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(superheroes) { hero in
                            SuperheroCard(
                                hero: hero,
                                isSelected: hero.imageName == selectedAvatarImage,
                                starsCollected: $starsCollected,
                                selectedAvatarImage: $selectedAvatarImage,
                                unlockedAvatars: $appState.unlockedAvatars
                            ) { name, cost, image in
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
        
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
    
    struct MagicCard: View {
        let magic: ShopView.MagicItem
        let isSelected: Bool
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
        
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if unlockedAvatars.contains(magic.imageName) {
                    selectedAvatarImage = magic.imageName
                } else {
                    if starsCollected >= magic.starCost {
                        requestPurchase(magic.name, magic.starCost, magic.imageName)
                    }
                }
            } label: {
                VStack(spacing: 6) {
                    
                    ZStack {
                        Image(magic.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .opacity(unlockedAvatars.contains(magic.imageName) ? 1.0 : 0.5)

                        if !unlockedAvatars.contains(magic.imageName) {
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(0.45))

                                Text("⭐ \(magic.starCost)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Text(magic.name)
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color(hex: "#0B2E52").opacity(0.85))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color(hex: "#F07B0F") : Color.clear, lineWidth: 3)
                )
            }
        }
    }
    
    struct MascotCard: View {
        let mascot: ShopView.AvatarItem
        let isSelected: Bool
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
                
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color(hex: "#F07B0F") : Color.clear, lineWidth: 3)
                )            }
        }
    }
    struct MysticCard: View {
        let mystic: ShopView.MysticItem
        let isSelected: Bool
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
        
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if unlockedAvatars.contains(mystic.imageName) {
                    selectedAvatarImage = mystic.imageName
                } else {
                    if starsCollected >= mystic.starCost {
                        requestPurchase(mystic.name, mystic.starCost, mystic.imageName)
                    }
                }
            } label: {
                VStack(spacing: 6) {
                    
                    ZStack {
                        Image(mystic.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipped()
                            .opacity((unlockedAvatars.contains(mystic.imageName) || mystic.starCost == 0) ? 1.0 : 0.5)

                        if !(unlockedAvatars.contains(mystic.imageName) || mystic.starCost == 0) {
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(0.45))

                                Text("⭐ \(mystic.starCost)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Text(mystic.name)
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color(hex: "#0B2E52").opacity(0.85))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color(hex: "#F07B0F") : Color.clear, lineWidth: 3)
                )
            }
        }
    }
    struct SuperheroCard: View {
        let hero: ShopView.SuperheroItem
        let isSelected: Bool
        
        @Binding var starsCollected: Int
        @Binding var selectedAvatarImage: String
        @Binding var unlockedAvatars: Set<String>
        var requestPurchase: (String, Int, String) -> Void
        
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if unlockedAvatars.contains(hero.imageName) {
                    selectedAvatarImage = hero.imageName
                } else {
                    if starsCollected >= hero.starCost {
                        requestPurchase(hero.name, hero.starCost, hero.imageName)
                    }
                }
            } label: {
                VStack(spacing: 6) {
                    
                    ZStack {
                        Image(hero.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .opacity(unlockedAvatars.contains(hero.imageName) ? 1.0 : 0.5)

                        if !unlockedAvatars.contains(hero.imageName) {
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(0.45))

                                Text("⭐ \(hero.starCost)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Text(hero.name)
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color(hex: "#0B2E52").opacity(0.85))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color(hex: "#F07B0F") : Color.clear, lineWidth: 3)
                )
            }
        }
    }
}
            

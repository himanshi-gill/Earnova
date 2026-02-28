import SwiftUI
import UIKit

struct ProfileView: View {
    
    @Binding var userName: String
    @Binding var selectedAvatarImage: String
    @Binding var coinGoal: Int
    @Binding var coinsCollected: Int
    @Binding var starsCollected: Int
    
    @State private var isEditingName = false
    
    var progress: Double {
        min(Double(coinsCollected) / Double(coinGoal), 1.0)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                           
                           // PROFILE TITLE
                           Text("Profile")
                               .font(.largeTitle.bold())
                               .foregroundColor(.white)
                               .padding(.top, 10)
                           
                           // GOAL PROGRESS
                           VStack(spacing: 8) {
                               HStack {
                                   Image(systemName: "star.fill")
                                       .foregroundColor(Color(hex: "#F07B0F"))
                                   Text("Coin Goal Progress")
                                       .font(.system(size: 20, weight: .semibold))
                                       .foregroundColor(.white)
                                   Spacer()
                               }
                               
                               ProgressView(value: progress)
                                   .tint(Color(hex: "#F07B0F"))
                                   .scaleEffect(x: 1, y: 2)
                               
                               Text("\(coinsCollected) / \(coinGoal) Coins")
                                   .font(.caption)
                                   .foregroundColor(Color(hex: "#E1E1D5"))
                           }
                           .padding()
                           .background(Color(hex: "#0B2E52").opacity(0.95))
                           .cornerRadius(20)
                           .padding(.horizontal)
                
                                VStack(spacing: 12) {
                                    
                                    Image(selectedAvatarImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 170, height: 170)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color(hex: "#F07B0F"), lineWidth: 4))
                                        .shadow(radius: 10)
                                    
                                    if isEditingName {
                                        TextField("Type your name", text: $userName)
                                            .padding()
                                            .background(Color(hex: "#1A4A7A")) // 🔹 darker background
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .multilineTextAlignment(.center)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                isEditingName = false
                                            }
                                    } else {
                                        Text(userName.isEmpty ? "Tap to add name" : userName)
                                            .font(.title2.bold())
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                isEditingName = true
                                            }
                                    }
                                }
                                .padding(.top)
                
                HStack(spacing: 40) {
                    VStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "#D1A75C"))
                        Text("\(starsCollected)")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))

                        Text("Stars")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#E1E1D5"))
                    }
                    
                    VStack {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .foregroundColor(Color(hex: "#F07B0F"))
                        Text("\(coinsCollected)")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))

                        Text("Coins")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#E1E1D5"))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#0B2E52").opacity(0.9))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // EDIT GOAL
                                VStack(spacing: 10) {
                                    Text("Set Your Coin Goal")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    HStack(spacing: 24) {

                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            coinGoal = max(50, coinGoal - 500)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.system(size: 26))
                                                .foregroundColor(.white)
                                        }

                                        Text("\(coinGoal)")
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundColor(.white)

                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            coinGoal = min(10000, coinGoal + 500)
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 26))
                                                .foregroundColor(.white)
                                        }
                                    }

                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#0B2E52").opacity(0.9))
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                        }
                        .onAppear {
                            if coinGoal == 0 {
                                coinGoal = 3500   // 🔹 default goal
                            }
                        }
                    }
                }

#Preview {
    ProfileView(
        userName: .constant("Himanshi"),
        selectedAvatarImage: .constant("animal1"),
        coinGoal: .constant(3000),
        coinsCollected: .constant(850),
        starsCollected: .constant(120)
    )
}

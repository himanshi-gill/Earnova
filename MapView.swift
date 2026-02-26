import SwiftUI

struct MapView: View {
    @Binding var coinsCollected: Int
    @Binding var starsCollected: Int
    
    @Binding var tasks: [Task]

    var avatarImages: [String] = ["animal1", "mascot1"]

    func refreshUniverse() {
        withAnimation(.easeInOut) {
            tasks.removeAll()
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {

            // ⭐ Coins & Stars (fixed at top)
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .foregroundColor(Color(hex: "#F07B0F"))
                            Text("Coins: \(coinsCollected)")
                                .foregroundColor(.white)
                                .bold()
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "#D1A75C"))
                            Text("Stars: \(starsCollected)")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                }
                Spacer()
            }

            // 🫧 Task Bubbles
            ZStack {
                ForEach($tasks) { $task in
                    @State var dragOffset = CGSize.zero

                    TaskBubble(task: task)
                        .offset(
                            x: task.xOffset + dragOffset.width,
                            y: task.yOffset + dragOffset.height
                        )
                        .modifier(HoverEffect())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    task.xOffset += value.translation.width
                                    task.yOffset += value.translation.height
                                    dragOffset = .zero
                                }
                        )
                }
            }

            // 🔄 Refresh Button
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        refreshUniverse()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 55, height: 55)
                            .background(Color(hex: "#F07B0F"))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    
    func pointOnPath(progress: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width - 100
        let height = UIScreen.main.bounds.height - 200
        
        let x = 50 + width * progress
        let y = 100 + sin(progress * .pi * 2) * (height / 4)
        
        return CGPoint(x: x, y: y)
    }
}


// Task Bubble View (UPDATED)
struct TaskBubble: View {
    var task: Task

    var body: some View {
        VStack(spacing: 6) {
            Image(task.avatarImage)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(task.type == .reward ? Color.green : Color.red, lineWidth: 3)
                )

            Text(task.title)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.blue)
                .cornerRadius(10)

            if task.type == .penalty {
                Text("-15 Coins")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}


struct HoverEffect: ViewModifier {
    @State private var hover: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: hover) // hover animation added on top of manual Y offset
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
                withAnimation(baseAnimation) {
                    hover = 10 // floating distance
                }
            }
    }
}


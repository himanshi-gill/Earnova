import SwiftUI

struct ConfirmationDialogView: View {
    let itemName: String
    let starCost: Int
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 22) {

            // Title
            Text("Purchase \(itemName)?")
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Message
            Text("This will cost ⭐ \(starCost).\nAre you sure you want to buy it?")
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .font(.body)

            // Buttons
            HStack(spacing: 16) {

                Button(action: onCancel) {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }

                Button(action: onConfirm) {
                    Text("Yes, Buy")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#F07B0F"),
                                    Color(hex: "#FF9A3D")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.orange.opacity(0.4), radius: 6, x: 0, y: 3)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#0B2E52"),
                    Color(hex: "#103B6D"),
                    Color(hex: "#0A2540")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 10)
    }
}

struct ConfirmationDialogView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ConfirmationDialogView(
                itemName: "Panda",
                starCost: 40,
                onConfirm: {},
                onCancel: {}
            )
        }
    }
}

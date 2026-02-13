import SwiftUI

struct QuickTaskDropdownView: View {

    let quickTasks: [String]
    @Binding var selectedTask: String

    var body: some View {
        Menu {
            ForEach(quickTasks, id: \.self) { task in
                Button(task) {
                    selectedTask = task
                }
            }
        } label: {
            Image(systemName: "chevron.down")
                .padding(10)
                .background(Color.white.opacity(0.15))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

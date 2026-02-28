import SwiftUI
import UIKit

struct CreateStoryView: View {
    @Binding var coinsCollected: Int
    @Binding var tasks: [Task]
    @Binding var selectedAvatarImage: String
    
    @State private var selectedTaskType: TaskType = .reward
    @State private var newTaskTitle = ""
    @State private var editingTaskIndex: Int? = nil
    
    let quickTasks = [
        "Drink Water",
        "Read 10 Pages",
        "Workout",
        "Meditation",
        "Study 1 Hour",
        "No Social Media"
    ]

    var body: some View {
        VStack(spacing: 0) {
            
            Text("Create New Task")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 10)
            VStack(spacing: 18) {
                HStack(spacing: 8) {

                    TextField("Enter task name", text: $newTaskTitle)
                        .foregroundColor(.white)

                    QuickTaskDropdownView(
                        quickTasks: quickTasks,
                        selectedTask: $newTaskTitle
                    )
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(14)

                if editingTaskIndex != nil {

                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        addTask()
                    } label: {
                        Label("Save Changes", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(radius: 4)
                    }

                } else {

                    HStack(spacing: 16) {

                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            selectedTaskType = .reward
                            addTask()
                        } label: {
                            Label("Reward +10", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }

                        Button {
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            selectedTaskType = .penalty
                            addTask()
                        } label: {
                            Label("Penalty -15", systemImage: "minus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }
                    }
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(hex: "#F07B0F"), Color(hex: "#D65A00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(tasks.indices, id: \.self) { index in
                        let task = tasks[index]

                        HStack(spacing: 10) {

                            Image(task.avatarImage)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 3)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(task.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(
                                        task.type == .reward
                                        ? Color(red: 0.65, green: 0.95, blue: 0.65)
                                        : Color(red: 1.0, green: 0.35, blue: 0.2)
                                    )

                                Text(task.createdAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                ))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            // EDIT BUTTON
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                editTask(at: index)
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            }

                            // DELETE BUTTON
                            Button {
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                deleteTask(at: index)
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(16)
                    }
                }
                .padding()
            }
        }
    }

    func addTask() {
        guard !newTaskTitle.isEmpty else { return }

        if let index = editingTaskIndex {

            let oldType = tasks[index].type
            let newType = selectedTaskType

            if oldType != newType {
                if oldType == .reward {
                    coinsCollected -= 10
                } else {
                    coinsCollected += 15
                }

                if newType == .reward {
                    coinsCollected += 10
                } else {
                    coinsCollected -= 15
                }
            }

            // Update task
            tasks[index].title = newTaskTitle
            tasks[index].type = newType

            editingTaskIndex = nil

        } else {
            let coinChange = selectedTaskType == .reward ? 10 : -15
            coinsCollected += coinChange

            let task = Task(
                id: UUID(),
                title: newTaskTitle,
                avatarImage: selectedAvatarImage,
                type: selectedTaskType,
                xOffset: CGFloat.random(in: -120...120),
                yOffset: CGFloat.random(in: -200...200),
                createdAt: Date()
            )

            tasks.append(task)
        }

        newTaskTitle = ""
    }
    
    func deleteTask(at index: Int) {
        let task = tasks[index]

        if task.type == .reward {
            coinsCollected -= 10
        } else {
            coinsCollected += 15
        }

        tasks.remove(at: index)

        if editingTaskIndex == index {
            editingTaskIndex = nil
            newTaskTitle = ""
        }
    }

    func editTask(at index: Int) {
        newTaskTitle = tasks[index].title
        selectedTaskType = tasks[index].type
        editingTaskIndex = index
    }
}

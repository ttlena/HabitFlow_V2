//
//  DailyHabitsComponent.swift
//  HabitFlow
//
//  Created by Lena Ngo on 25.05.23.
//

import SwiftUI

struct DailyHabitsComponent: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var habits: FetchedResults<Habit>

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        
        VStack {
            Text("Tägliche Habits")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(habits, id: \.self) { habit in
                        VStack() {
                            HStack() {
                                Image(habit.icon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text(habit.name ?? "Unknown")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            CircularProgressView(progress: habit.progress)
                                .frame(width: 150)
                            Text("\(habit.current)/\(habit.goal)")
                        }
                        .background(Color(UIColor.darkGray))
                        .cornerRadius(10)
                    }
                }
            }
            .frame(height: 500)
            
            Button("add") {
                addRandomHabit()
            }
            Button("delete") {
                deleteHabits()
            }
            
        }
    }
    func addRandomHabit() {
        let task = ["clean", "wash", "study", "workout"]
        let chosenTask = task.randomElement()!
        let habit = Habit(context: moc)
        habit.id = UUID()
        habit.icon = "Waterdrop"
        habit.name = "\(chosenTask)"
        habit.current = Int16.random(in: 0...10)
        habit.goal = Int16.random(in: 5...100)
        habit.progress = Double(habit.current) / Double(habit.goal)
        try? moc.save()
    }
    
    func deleteHabits() {
        for idx in 0...(habits.count-1) {
            let habit = habits[idx]
            moc.delete(habit)
        }
        try? moc.save()
    }
}

struct DailyHabitsComponent_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitsComponent()
    }
}

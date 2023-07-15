//
//  DailyHabitsComponent.swift
//  HabitFlow
//
//  Created by Lena Ngo on 25.05.23.
//

import SwiftUI

struct DailyHabitsComponent: View {
    @EnvironmentObject var habitsVM: HabitViewModel
    
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
                    ForEach(habitsVM.habits, id: \.self) { habit in
                        VStack() {
                            HStack() {
                                Image(habit.icon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text(habit.title ?? "Unknown")
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
                habitsVM.addRandomHabit()
            }
            Button("delete") {
                habitsVM.deleteAll()
            }
            
        }
    }
}

struct DailyHabitsComponent_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitsComponent()
    }
}

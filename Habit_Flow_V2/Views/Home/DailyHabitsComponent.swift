//
//  DailyHabitsComponent.swift
//  HabitFlow
//
//  Created by Lena Ngo on 25.05.23.
//

import SwiftUI

struct DailyHabitsComponent: View {
    @StateObject var habitsVM: HabitViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        
        VStack {
            Text("Heutige Habits")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            if habitsVM.habits.isEmpty {
                VStack {
                    Text("Heute hast du kein Habit zu erfüllen!")
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.darkGray))
                .cornerRadius(10)
            } else {
                List {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(habitsVM.getHabitsBasedOnWeekday(habits: habitsVM.habits, pickedDate: Date()), id: \.self) { habit in
                            HabitTile(habit: habit, habitVM: habitsVM)
                                .frame(width: 175, height: 280) // Hier die gewünschte Breite und Höhe einstellen
                            
                        }
                    }
                }
                .listStyle(.plain)
                .frame(height: 500)
            }
        }
    }
}

struct DailyHabitsComponent_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitsComponent(habitsVM: HabitViewModel())
    }
}

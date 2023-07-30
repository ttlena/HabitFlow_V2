//
//  HabitTile.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 25.07.23.
//

import SwiftUI

struct HabitTile: View {
    let habit:Habit
    @StateObject var habitVM: HabitViewModel
    
    var body: some View {
        VStack() {
            HStack() {
//                Image(habit.icon ?? "")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 20)
                Text(habit.title ?? "Unknown")
                    .foregroundColor(.white)
            }
            .padding()
            CircularProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
            Text("\(habit.current)/\(habit.goal)")
        } 
        .padding(10)
    }
}

struct HabitTile_Previews: PreviewProvider {
    static var previews: some View {
        HabitTile(habit: Habit(), habitVM: HabitViewModel())
    }
}

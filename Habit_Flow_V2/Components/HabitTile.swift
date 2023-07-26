//
//  HabitTile.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 25.07.23.
//

import SwiftUI

struct HabitTile: View {
    let habit:Habit
    
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
            CircularProgressView(progress: habit.progress)
            Text("\(habit.current)/\(habit.goal)")
        }
    }
}

struct HabitTile_Previews: PreviewProvider {
    static var previews: some View {
        HabitTile(habit: Habit())
    }
}

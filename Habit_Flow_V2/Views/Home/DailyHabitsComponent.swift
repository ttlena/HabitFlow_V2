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
            HStack {
                Text("Heutige Habits")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                Text("\(habitsVM.habitsToday.count - habitsVM.habitsTodayRemovingList.count)/\(habitsVM.habitsToday.count)")
                    .padding(10)
                    .padding([.horizontal], 15)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 15))
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
            }
            if habitsVM.habitsToday.isEmpty {
                VStack {
                    Text("Heute hast du kein Habit zu erfüllen!")
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.darkGray))
                .cornerRadius(10)

            } else if (habitsVM.habitsTodayRemovingList.isEmpty) {
                VStack {
                    Text("Heute hast du alle Habits erfüllt!")
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.darkGray))
                .cornerRadius(10)
            }
            
            else {
                List {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(habitsVM.habitsTodayRemovingList, id: \.self) { habit in
                            HabitTile(habit: habit, habitVM: habitsVM)
                                .frame(width: 175, height: 280) 
                            
                        }
                    }
                }
                .listStyle(.plain)
                .frame(height: 500)
            }
        }
        .onAppear{
            habitsVM.checkIfResetNecessary()
        }
    }
}

struct DailyHabitsComponent_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitsComponent(habitsVM: HabitViewModel())
    }
}

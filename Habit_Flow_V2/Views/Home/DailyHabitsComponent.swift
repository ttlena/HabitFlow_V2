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
            Text("Tägliche Habits")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(habitsVM.habits, id: \.self) { habit in
                        HabitTile(habit: habit)
                            .background(Color(UIColor.darkGray))
                            .cornerRadius(10)
                    }
                }
            }
            .frame(height: 500)
        }
    }
}

struct DailyHabitsComponent_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitsComponent(habitsVM: HabitViewModel())
    }
}

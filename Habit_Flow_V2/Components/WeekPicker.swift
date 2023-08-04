//
//  WeekPicker.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 30.07.23.
//

import SwiftUI

struct WeekPicker: View {
    @StateObject var habitVM: HabitViewModel
    
    var body: some View {
        VStack {
            HStack() {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(habitVM.selectedDays.contains(day.lowercased()) ? Color.orange.cornerRadius(25) : Color.gray.cornerRadius(25))
                        .onTapGesture {
                            habitVM.toggleDaySelection(day: day)
                        }
                }
            }
  
        }
        .padding(.vertical)
    }
    
    private let daysOfWeek = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
}

struct WeekPicker_Preview:PreviewProvider {
    static var previews: some View {
        WeekPicker(habitVM: HabitViewModel())
    }
}

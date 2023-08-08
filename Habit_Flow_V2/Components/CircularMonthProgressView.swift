//
//  CircularMonthProgressView.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 31.07.23.
//

import SwiftUI

struct CircularMonthProgressView: View {
    let progress: Double
    @StateObject var habitVM: HabitViewModel
    var habit: Habit
    
    var body: some View {
        ZStack() {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 15
                )
            Circle()
                .trim(from: 0, to: Double(habit.currentInMonth) / Double(habit.goalInMonth)) // 1
                .stroke(
                    Color.orange,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: Double(habit.currentInMonth) / Double(habit.goalInMonth))
            Circle()
                .foregroundColor(.clear)
            
            if(habit.currentInMonth >= habit.goalInMonth) {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green)
                    .font(.system(size: 20, weight: .bold))
            } else {
                /*Image("Plus")
                    .resizable()
                    .frame(width: 30, height: 30)*/
                
            }
        }
        .padding(10)
    }
}

                      

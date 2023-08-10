//
//  CircularProgressView.swift
//  HabitFlow
//
//  Created by Lena Ngo on 31.05.23.
//

import SwiftUI

struct CircularProgressView: View {
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
                .trim(from: 0, to: habit.progress) // 1
                .stroke(
                    Color.orange,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: habit.progress)
            Circle()
                .foregroundColor(.clear)
            
            if(habit.current >= habit.goal) {
                Button(action: {
                    habitVM.plusButtonClicked = true
                    habitVM.setCurrentTo0(habit: habit)
                }) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                        .font(.system(size: 20, weight: .bold))
                }
            } else {
                Button(action: {
                    habitVM.plusButtonClicked = true
                    habitVM.countUpHabbitDuration(habit: habit)
                }) {
                    Image("Plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding(10)
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.4, habitVM: HabitViewModel(), habit: Habit())
    }
}

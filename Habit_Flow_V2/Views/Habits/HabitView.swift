//
//  HabitView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import SwiftUI

struct HabitsView: View {
    
    @EnvironmentObject var habitsViewModel : HabitViewModel
    @State var showingBottomSheet = false
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack{
            HStack{
                Text("Daily Habits")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("0/\(habitsViewModel.habits.count)")
                    .padding(10)
                    .padding([.horizontal], 15)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
            }
            .padding([.horizontal], 25)
//            .padding([.bottom], 50)
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(habitsViewModel.habits, id: \.self) { habit in
                            HabitTile(habit: habit)
                                .background(Color(UIColor.darkGray))
                                .cornerRadius(10)
                        }
                    }
                    .padding([.bottom], 110)
                }
                PrimaryButton(labelMessage: "neues Habit", symbol: "plus", action: {
                    newHabit()
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding([.bottom], 50)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .sheet(isPresented: $showingBottomSheet) {
                AddHabitSheetView(habitVM: habitsViewModel)
                    .presentationDetents([.medium, .large])
            }
            
        }
    }
    
    func newHabit() {
        showingBottomSheet.toggle()
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitsView()
        }
        .environmentObject(HabitViewModel())
    }
    
}

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
                Text("Habits")
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
            
            
            if(habitsViewModel.habits.count <= 0){
                
                Text("Noch keine Habits angelegt.")
                    .font(.title3)
                    //.frame(alignment: .leading)
                    .padding([.top], 180)
            }
            
            ZStack {
            
                    List {
                        LazyVGrid(columns: columns, spacing: 0) {
                            
                            ForEach(habitsViewModel.habits, id: \.self) { habit in
                                HabitTile(habit: habit, habitVM: habitsViewModel)
                                    .frame(width: 190, height: 280)

                            }
                        }
                    }
                    .listStyle(.plain)
                
               
                
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
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
            habitsViewModel.checkIfResetNecessary()
        }
    }
    
    func newHabit() {
        showingBottomSheet.toggle()
        habitsViewModel.resetHabitEntry()
    }
    
    func calculateHabitTileHeight(for geometry: GeometryProxy) -> CGFloat {
        return min(geometry.size.width * 0.5, 200)
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

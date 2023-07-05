//
//  HabitView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import SwiftUI

struct HabitsView: View {
    
    @EnvironmentObject var HabitViewModel : HabitViewModel
    @State var showingBottomSheet = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Daily Habits")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("0 / 0")
                    .padding(10)
                    .padding([.horizontal], 15)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
            }
            .padding([.horizontal], 25)
            
            
  
            
            
            Button(action: newHabit, label: {Text("+ neues Habit")})
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(32)
                .padding([.horizontal], 100)
            
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding([.bottom], 50)
        
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showingBottomSheet) {
            AddHabitSheetView()
                .presentationDetents([.medium, .large])
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

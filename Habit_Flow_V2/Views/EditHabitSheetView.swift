//
//  EditHabitSheetView.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 10.08.23.
//

import SwiftUI

struct EditHabitSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var habitVM: HabitViewModel
    let habit: Habit

    
    var body: some View {
        VStack {
            Text("Habit bearbeiten")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            TextField("Titel", text: $habitVM.editHabitTitle)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            /*TextField("Häufigkeit in einer Woche", value: $habitVM.newHabitDuration, format: .number)
             .keyboardType(.numberPad)
             //                        .onReceive(Just(durationInput)) { newValue in
             //                            let filtered = newValue.filter { "0123456789".contains($0) }
             //                            if filtered != newValue {
             //                                self.durationInput = filtered
             //                            }
             //                        }
             .padding(.horizontal)
             .frame(height: 41)
             .background(Color(UIColor.systemGray2))
             .cornerRadius(12)*/
            
            
            VStack {
                WeekPicker(habitVM: habitVM)
            }
            
            Button(action: {
               /* habitVM.saveNewHabit()
                presentationMode.wrappedValue.dismiss()
                habitVM.resetHabitEntry() */
            }, label: {
                Text("Speichern")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(32)
                    .padding([.horizontal], 70)
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .padding(39)
        .alert(isPresented: $habitVM.showAlert) {
            Alert(title: Text("NOPE!"), message: Text(habitVM.alertTitle), dismissButton: .default(Text("OK")))
        }
    }
    
}

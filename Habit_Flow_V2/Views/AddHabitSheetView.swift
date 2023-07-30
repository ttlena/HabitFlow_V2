//
//  AddHabitSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI
import Combine

struct AddHabitSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var habitVM: HabitViewModel
    
    var body: some View {
        VStack {
            Text("Neues Habit")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            TextField("Titel", text: $habitVM.newHabitTitle)
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
                habitVM.saveNewHabit()
                presentationMode.wrappedValue.dismiss()
                habitVM.resetHabitEntry()
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
    
    //    func saveButtonPressed() {
    //        print("pressed")
    //        if textIsAppropiate() {
    //            habitVM.addData()
    //            toDosViewModel.addItem(title: textFieldText)
    //            presentationMode.wrappedValue.dismiss()
    //        }
    //    }
    
    //    func textIsAppropiate() -> Bool {
    //        if textFieldText.count < 3 {
    //            alertTitle = "Der Titel sollte mindestens eine Länge von 3 Zeichen haben!"
    //            showAlert.toggle()
    //            return false
    //        }
    //        return true
    //    }
}


struct AddHabitSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitSheetView(habitVM: HabitViewModel())
    }
}

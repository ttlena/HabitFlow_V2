//
//  AddHabitSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI

struct AddHabitSheetView: View {
    @State var textFieldText: String=""
    @State var durationInput: String=""
    
    var body: some View {
        VStack {
            Text("Neues Habit")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            TextField("Titel", text: $textFieldText)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            TextField("Dauer in Tagen", text: $durationInput)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            Button(action: saveButtonPressed, label: {
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
    }
    
    func saveButtonPressed() {
        print("pressed")
    }
}


struct AddHabitSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitSheetView()
    }
}

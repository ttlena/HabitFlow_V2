//
//  AddCalendarSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI

struct AddCalendarSheetView: View {
    
    @State var textFieldText: String=""
    
    var body: some View {
        VStack {
            Text("Neues Ereignis")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("Titel")
            
            TextField("Titel", text: $textFieldText)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            Text("Standort")
            
            Text("Datum")
            
            
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

struct AddCalendarSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCalendarSheetView()
    }
}

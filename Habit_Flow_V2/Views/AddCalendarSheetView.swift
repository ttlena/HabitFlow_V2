//
//  AddCalendarSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI

struct AddCalendarSheetView: View {
    
    @State var textFieldText: String=""
    @State var date = Date()
    
    var body: some View {
        VStack {
            Text("Neues Ereignis")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
     
            TextField("Titel", text: $textFieldText)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            //Text("Standort")
            

            DatePicker("Datum", selection: $date, in: Date()...)//.datePickerStyle(.graphical)
                .accentColor(.orange)
                //.background(Color.gray.opacity(0.4), in: RoundedRectangle(cornerRadius: 20)).padding()
                .environment(\.locale, Locale.init(identifier: "de_DE"))
            
            
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

//
//  AddCalendarSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI

struct AddCalendarSheetView: View {
    @EnvironmentObject var calendarVM: CalendarViewModel
    
    var body: some View {
        VStack {
            Text("Neues Ereignis")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
     
            TextField("Titel", text: $calendarVM.newEventTitle)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            
            //Text("Standort")
            

            DatePicker("Datum", selection: $calendarVM.newEventDate, in: Date()...)//.datePickerStyle(.graphical)
                .accentColor(.orange)
                //.background(Color.gray.opacity(0.4), in: RoundedRectangle(cornerRadius: 20)).padding()
                .environment(\.locale, Locale.init(identifier: "de_DE"))
            
            
            Button(action: calendarVM.addNewAppointment, label: {
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
    
}

struct AddCalendarSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCalendarSheetView()
    }
}

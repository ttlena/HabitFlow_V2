//
//  CalenderView.swift
//  HabitFlow
//
//  Created by Florian Bohn on 30.05.23.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var calendar: CalendarViewModel
    
    var body: some View {
        VStack {
            Text("Kalender").font(.title)
            DatePicker(
                "Start Date",
                selection: $calendar.pickedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(.orange)
            .background(Color.gray.opacity(0.4), in: RoundedRectangle(cornerRadius: 20)).padding()
            .environment(\.locale, Locale.init(identifier: "de_DE"))
            
            PrimaryButton(labelMessage: "neuer Termin", symbol: "plus", action: {
                print("printed")
                
            }).frame(maxHeight: .infinity, alignment: .bottom)
                .padding(40)
        
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

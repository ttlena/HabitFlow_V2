//
//  CalenderView.swift
//  HabitFlow
//
//  Created by Florian Bohn on 30.05.23.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var calendar: CalendarViewModel
    @State var showingBottomSheet = false
    
    var body: some View {
        VStack {
            Text("Kalender")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 25)
            DatePicker(
                "Start Date",
                selection: $calendar.pickedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(.orange)
            .background(Color.gray.opacity(0.4), in: RoundedRectangle(cornerRadius: 20)).padding()
            .environment(\.locale, Locale.init(identifier: "de_DE"))
            
            Button(action: newDate, label:{
                Text("+ neuer Termin")
            })
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
        
        .sheet(isPresented: $showingBottomSheet) {
            AddCalendarSheetView()
                .presentationDetents([.medium, .large])
        }
        
        
    }
    
    func newDate() {
        showingBottomSheet.toggle()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(CalendarViewModel())
    }
}

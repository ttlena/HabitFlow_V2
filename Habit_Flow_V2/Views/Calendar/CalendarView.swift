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
            
//            CalenderList(event: "Laufen", eventType: "Habit", time: "20:00", imageName: "checkmark", recColor: Color.red)
//            CalenderList(event: "Arzt", eventType: "Termin", time: "23:00", imageName: "checkmark", recColor: Color.blue)
            ScrollView {
                if let dailyAppointments = calendar.structuredAppointmentsMap[calendar.deleteClockComponentFromDate(date: calendar.pickedDate)] {
                    ForEach(dailyAppointments, id: \.self) { event in
                        CalenderList(
                            event: event.title ?? "",
                            eventType: "Termin",
                            time: calendar.extractTimeFromDate(event.date ?? Date()),
                            imageName: "checkmark",
                            recColor: Color.red
                        )
                    }
                }
            }
            
            PrimaryButton(labelMessage: "neuer Termin", symbol: "plus", action: {
                calendar.toggleBottomSheet()
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .padding([.bottom], 50)
        .sheet(isPresented: $calendar.showingBottomSheet) {
            AddCalendarSheetView()
                .presentationDetents([.medium, .large])
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(CalendarViewModel())
    }
}

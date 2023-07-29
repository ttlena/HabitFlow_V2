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
            List {
                if let dailyAppointments = calendar.structuredAppointmentsMap[calendar.deleteClockComponentFromDate(date: calendar.pickedDate)] {
                    ForEach(dailyAppointments, id: \.self) { event in
                        CalenderList(
                            event: event.title ?? "",
                            eventType: "Termin",
                            time: calendar.extractTimeFromDate(event.date ?? Date()),
                            endTime: calendar.extractTimeFromDate(event.endDate ?? Date()),
                            imageName: "checkmark",
                            recColor: Color.red,
                            calendarVM: calendar,
                            id: event.id.unsafelyUnwrapped
                        )
                    }
                    .onDelete { indices in
                        for index in indices {
                            if index < dailyAppointments.count {
                                calendar.deleteAppointment(index: index)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            // ...
            
            PrimaryButton(labelMessage: "neuer Termin", symbol: "plus", action: {
                calendar.toggleBottomSheet()
            })
            
        }
        .padding([.bottom], 50)
        .sheet(isPresented: $calendar.showingBottomSheet) {
            AddCalendarSheetView(calendarVM: calendar)
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

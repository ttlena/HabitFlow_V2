//
//  CalendarTodayComponent.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 11.08.23.
//

import SwiftUI

struct CalendarTodayComponent: View {
    @StateObject var calendarVM: CalendarViewModel
    var body: some View {
        Text("Nächster Termin")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
        if let nextAppointment = calendarVM.getNextAppointmentForToday() {
            CalendarElement(
                event: nextAppointment.title ?? "",
                eventType: "",
                time: calendarVM.extractTimeFromDate(nextAppointment.date ?? Date()),
                endTime: calendarVM.extractTimeFromDate(nextAppointment.endDate ?? Date()),
                
                imageName: "checkmark",
                recColor: colorFromString(nextAppointment.color ?? "red"),
                calendarVM: calendarVM,
                id: nextAppointment.id.unsafelyUnwrapped,
                isHabit: true
            )
            
        }else {
            VStack {
                Text("Du hast heute keine Termine mehr!")
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.darkGray))
            .cornerRadius(10)
        }
    }
    
    func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "rot":
            return .red
        case "blau":
            return .blue
        case "grün":
            return .green
        case "gelb":
            return .yellow
        default:
            return .red
        }
    }
}

struct CalendarTodayComponent_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTodayComponent(calendarVM: CalendarViewModel())
    }
}

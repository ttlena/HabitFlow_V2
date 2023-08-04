//
//  CalenderView.swift
//  HabitFlow
//
//  Created by Florian Bohn on 30.05.23.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var calendar: CalendarViewModel
    @State private var showDatePicker = true
    @StateObject  var habitVM: HabitViewModel
    
    var body: some View {
        VStack {
            Text("Kalender")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 25)
            
            VStack {
                HStack {
                    Text("Datum")
                        .foregroundColor(.primary)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: calendar.pickedDate))
                        .foregroundColor(.orange)
                        .font(.headline)
                    
                    Image(systemName: showDatePicker ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                        .font(.headline)
                        .padding(.leading, 8)
                }
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(20)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showDatePicker.toggle()
                    }
                }
                .frame(height: showDatePicker ? nil : 60)
                
                if showDatePicker {
                    DatePicker(
                        "Start Date",
                        selection: $calendar.pickedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                    //.padding(.bottom)
                }
            }

            
            //            CalenderList(event: "Laufen", eventType: "Habit", time: "20:00", imageName: "checkmark", recColor: Color.red)
            //            CalenderList(event: "Arzt", eventType: "Termin", time: "23:00", imageName: "checkmark", recColor: Color.blue)
            
            VStack {
                List {
                    if let dailyAppointments = calendar.structuredAppointmentsMap[calendar.deleteClockComponentFromDate(date: calendar.pickedDate)] {
                        Text("Termine")

                        ForEach(dailyAppointments, id: \.self) { event in
                            CalenderList(
                                event: event.title ?? "",
                                eventType: "Termin",
                                time: calendar.extractTimeFromDate(event.date ?? Date()),
                                endTime: calendar.extractTimeFromDate(event.endDate ?? Date()),
                                
                                imageName: "checkmark",
                                //recColor: Color(.green),
                                recColor: colorFromString(event.color ?? "red"),
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
                        Text("Habits")

                        ForEach(habitVM.getHabitsBasedOnWeekday(habits: habitVM.habits, pickedDate: calendar.pickedDate)) { habit in
                            CalenderList(event: habit.title ?? "", eventType: "", time: "", endTime: "", imageName: "", recColor: Color.blue, calendarVM: calendar, id: habit.id.unsafelyUnwrapped)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            
            PrimaryButton(labelMessage: "neuer Termin", symbol: "plus", action: {
                calendar.toggleBottomSheet()
            })
            
        }
        .onAppear{UIApplication.shared.applicationIconBadgeNumber = 0}
        .padding([.bottom], 50)
        .sheet(isPresented: $calendar.showingBottomSheet) {
            AddCalendarSheetView(calendarVM: calendar)
                .presentationDetents([.large])
        }
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
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


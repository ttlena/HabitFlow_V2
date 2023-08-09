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
                }
            }
            
            VStack {
                List {
                    if let dailyAppointments = calendar.structuredAppointmentsMap[calendar.deleteClockComponentFromDate(date: calendar.pickedDate)] {
                        Text("Termine")
                        
                        ForEach(dailyAppointments, id: \.self) { event in
                            CalendarElement(
                                event: event.title ?? "",
                                eventType: "",
                                time: calendar.extractTimeFromDate(event.date ?? Date()),
                                endTime: calendar.extractTimeFromDate(event.endDate ?? Date()),
                                
                                imageName: "checkmark",
                                recColor: colorFromString(event.color ?? "red"),
                                calendarVM: calendar,
                                id: event.id.unsafelyUnwrapped,
                                isHabit: false
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
                    if habitVM.pickedTodayHabits != [] {
                        Text("Habits")
                        ForEach(habitVM.pickedTodayHabits) { habit in
                            CalendarElement(
                                event: habit.title ?? "",
                                eventType: "", time: "",
                                endTime: "", imageName: "",
                                recColor: Color.orange,
                                calendarVM: calendar,
                                id: habit.id.unsafelyUnwrapped,
                                isHabit: true
                            )
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
        .onChange(of: calendar.pickedDate) { newDate in
            habitVM.pickedTodayHabits = habitVM.getHabitsBasedOnWeekday(pickedDate: calendar.pickedDate)
        }
        .onAppear {
            habitVM.pickedTodayHabits = habitVM.getHabitsBasedOnWeekday(pickedDate: calendar.pickedDate)
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


import SwiftUI

struct EventColor: Identifiable {
    let id = UUID()
    let name: String // Ändern Sie den Typ auf String
    let color: Color
}

let colorPalette: [EventColor] = [
    EventColor(name: "Red", color: .red),
    EventColor(name: "Blue", color: .blue),
    EventColor(name: "Green", color: .green),
    EventColor(name: "Orange", color: .orange)
]

struct ColorPickerView: View {
    @Binding var selectedColorName: String? // Hinzufügen des ausgewählten Farbnamen-Bindings

    var body: some View {
        HStack {
            ForEach(colorPalette) { color in
                Button(action: {
                    selectedColorName = color.name // Den ausgewählten Farbnamen setzen
                }) {
                    Circle()
                        .fill(color.color)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColorName == color.name ? 3 : 0)
                        )
                }
            }
        }
        .padding(.horizontal)
    }
}



struct AddCalendarSheetView: View {
    @StateObject var calendarVM: CalendarViewModel
    
    @State private var selectedColorName: String?
    
    var body: some View {
        VStack {
            if calendarVM.isAppointmentEdited {
                Text("Termin bearbeiten")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(0.0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                TextField("Titel", text: $calendarVM.editedTitle)
                    .padding(.horizontal)
                    .frame(height: 41)
                    .background(Color(UIColor.systemGray2))
                    .cornerRadius(12)
                
                DatePicker("Datum (Beginn)", selection: $calendarVM.editedDate, in: Date()...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
                DatePicker("Datum (Ende)", selection: $calendarVM.editedEndDate, in: calendarVM.editedDate...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
                
                
                Toggle(isOn: $calendarVM.editedEventReminder, label: {
                    Text("Erinnerung")
                })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(12)
                
                ScrollView {
                    if calendarVM.editedEventReminder {
                        VStack {
                            Text("Erinnerung  \(calendarVM.editedEventReminderMinutes) Minuten vor beginn")
                                .padding(.vertical)
                            
                            Picker("Anzahl von Minuten", selection: $calendarVM.editedEventReminderMinutes) {
                                ForEach(0...120, id: \.self) { minute in
                                    Text("\(minute) Minuten")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 150)
                            .clipped()
                            .padding(.horizontal)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)
                        }
                    }
                }
                
                
                
                Button(action: calendarVM.editAppointment, label: {
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
                
            } else {
                Text("Neuer Termin")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(0.0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                TextField("Titel", text: $calendarVM.newEventTitle)
                    .padding(.horizontal)
                    .frame(height: 41)
                    .background(Color(UIColor.systemGray2))
                    .cornerRadius(12)
                
                DatePicker("Datum (Beginn)", selection: $calendarVM.newEventDate, in: Date()...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
                DatePicker("Datum (Ende)", selection: $calendarVM.newEventEndDate, in: calendarVM.newEventDate...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
                
                Text("Event Color")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .padding(.top)

                ColorPickerView(selectedColorName: $selectedColorName)

                
                Toggle(isOn: $calendarVM.newEventReminder, label: {
                                Text("Erinnerung")
                            })
                .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)

                ScrollView {
                    if calendarVM.newEventReminder {
                        VStack {
                            Text("Erinnerung  \(calendarVM.newEventReminderMinutes) Minuten vor beginn")
                                .padding(.vertical)
                            
                            Picker("Anzahl von Minuten", selection: $calendarVM.newEventReminderMinutes) {
                                ForEach(0...120, id: \.self) { minute in
                                    Text("\(minute) Minuten")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 150)
                            .clipped()
                            .padding(.horizontal)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)
                        }
                    }
                }
                
                
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
        }
        .padding(39)
    }
}

struct AddCalendarSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCalendarSheetView(calendarVM: CalendarViewModel())
    }
}

import SwiftUI


struct AddCalendarSheetView: View {
    @StateObject var calendarVM: CalendarViewModel
    
    @State private var selectedColorIndex = 0
       
       // Define an array of colors to choose from
    let colorPalette: [(name: String, color: Color)] = [
        (name: "Rot", color: .red),
        (name: "Blau", color: .blue),
        (name: "Grün", color: .green),
        (name: "Gelb", color: .yellow)
        ]

    
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
                
                
                HStack(spacing: 4) {
                               ForEach(colorPalette.indices, id: \.self) { index in
                                   Button(action: {
                                       selectedColorIndex = index
                                       calendarVM.editedEventColor = colorPalette[index].name 
                                   }) {
                                       Text("\(colorPalette[index].name)")
                                           .foregroundColor(.white)
                                           .frame(maxWidth: .infinity)
                                           .frame(height: 30)
                                           .padding(.horizontal, 8)
                                           .background(
                                               index == selectedColorIndex ? colorPalette[index].color : Color.clear
                                           )
                                           .cornerRadius(15)
                                           .lineLimit(1)
                                   }
                               }
                           }
                           .padding()
                           .background(Color(UIColor.systemGray5))
                           .cornerRadius(12)
                
                
                
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
                
                
                
                Button(action: editButtonPressed, label: {
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
                
                
                Text("Termin Farbe")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .padding(.top)

               
                HStack(spacing: 4) { // Hinzugefügter Spacing zwischen den Buttons
                               ForEach(colorPalette.indices, id: \.self) { index in
                                   Button(action: {
                                       selectedColorIndex = index
                                       calendarVM.newEventColor = colorPalette[index].name // Übergebe die SwiftUI-Farbe
                                   }) {
                                       Text("\(colorPalette[index].name)")
                                           .foregroundColor(.white)
                                           .frame(maxWidth: .infinity)
                                           .frame(height: 30) // Begrenze die Höhe der Buttons
                                           .padding(.horizontal, 8) // Füge horizontalen Padding hinzu
                                           .background(
                                               index == selectedColorIndex ? colorPalette[index].color : Color.clear // Hervorheben der ausgewählten Farbe
                                           )
                                           .cornerRadius(15) // Runde die Ecken
                                           .lineLimit(1) // Begrenze den Text auf eine Zeile
                                   }
                               }
                           }
                           .padding()
                           .background(Color(UIColor.systemGray5))
                           .cornerRadius(12)

                
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
        }
        .padding(39)
        .onChange(of: selectedColorIndex, perform: { value in
                    // Aktualisiere die ausgewählte Farbe im ViewModel
                    calendarVM.newEventColor = colorPalette[selectedColorIndex].name
                })
    }
    func saveButtonPressed() {
        calendarVM.addNewAppointment()
        selectedColorIndex = 0
    }
    
    func editButtonPressed() {
        calendarVM.editAppointment()
        selectedColorIndex = 0
    }
}

struct AddCalendarSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCalendarSheetView(calendarVM: CalendarViewModel())
    }
}

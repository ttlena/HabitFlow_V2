import SwiftUI

struct AddCalendarSheetView: View {
    @StateObject var calendarVM: CalendarViewModel
    
    var body: some View {
        VStack {
            if calendarVM.isAppointmentEdited {
                Text("Ereignis bearbeiten")
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
                
                DatePicker("Datum (Beginn)", selection: $calendarVM.newEventDate, in: Date()...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
                DatePicker("Datum (Ende)", selection: $calendarVM.newEventEndDate, in: calendarVM.newEventDate...)
                    .accentColor(.orange)
                    .environment(\.locale, Locale(identifier: "de_DE"))
                
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

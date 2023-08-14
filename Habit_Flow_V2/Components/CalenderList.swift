//
//  CalenderList.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 05.07.23.
//

import SwiftUI
import Foundation

struct CalenderList: View {
    var event: String
    var eventType : String
    var time : String
    var endTime : String
    var imageName: String
    var recColor: Color
    @Environment(\.colorScheme) var colorScheme
    @StateObject var calendarVM: CalendarViewModel
    var id : UUID
    var isHabit: Bool
    
    let gridItems = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
    ]
    
    init(event: String, eventType: String, time: String, endTime: String,  imageName: String, recColor: Color, calendarVM: CalendarViewModel, id: UUID, isHabit: Bool) {
        self.event = event
        self.eventType = eventType
        self.time = time
        self.endTime = endTime
        self.imageName = imageName
        self.recColor = recColor
        self._calendarVM = StateObject(wrappedValue: calendarVM)
        self.id = id
        self.isHabit = isHabit
    }
    
    var body: some View {
        Button(action: {
            if !isHabit {
                calendarVM.setCurrentEditedAppointmentById(id: self.id)
                calendarVM.toggleBottomSheetEditAppointment() 
            }
        }) {
            VStack {
                HStack {
                    HStack {
                        Rectangle()
                            .frame(width: 10, height: 20)
                            .foregroundColor(recColor)
                        Text(event)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text(eventType)
                        .fontWeight(.thin)
                        .padding(.horizontal, 20)
                    VStack(alignment: .trailing) {
                        Text(time)
                            .lineLimit(1)
                        Text(endTime)
                            .lineLimit(1)
                    }
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)) // Hier habe ich den linken und rechten Paddingwert auf 20 gesetzt, du kannst sie nach Bedarf anpassen.
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}

struct CalenderList_Previews: PreviewProvider {
    static var previews: some View {
        let calendarVM = CalendarViewModel()
        return CalenderList(event: "Trainieren", eventType: "Habit", time: "20:00", endTime: "22:00", imageName: "checkmark", recColor: Color.red, calendarVM: calendarVM, id: UUID(), isHabit: false)
    }
}

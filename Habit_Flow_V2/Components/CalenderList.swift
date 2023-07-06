//
//  CalenderList.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 05.07.23.
//

import SwiftUI

struct CalenderList: View {
    var event: String
    var eventType : String
    var time : String
    var imageName: String
    var recColor: Color
    
    let gridItems = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
    ]
    
    init(event: String, eventType: String, time: String, imageName: String, recColor: Color) {
        self.event = event
        self.eventType = eventType
        self.time = time
        self.imageName = imageName
        self.recColor = recColor
    }
    
    var body: some View {
        VStack{
            LazyVGrid(columns: gridItems) {
                HStack(alignment: .top) {
                    HStack {
                        Rectangle()
                            .frame(width: 10, height: 20)
                            .foregroundColor(recColor)
                        Text(event)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                Text(eventType)
                    .fontWeight(.thin)
                Text(time)
                    .lineLimit(1)
                Image(systemName: imageName)
                    .foregroundColor(Color.orange)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            
        }
    }
}

struct CalenderList_Previews: PreviewProvider {
    static var previews: some View {
        CalenderList(event: "Trainieren", eventType: "Habit", time: "20:00-21:00", imageName: "checkmark",recColor: Color.red)
    }
}

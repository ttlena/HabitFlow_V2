//
//  ToDoToday.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 20.06.23.
//

import SwiftUI

struct ToDoTodayComponent: View {
    @EnvironmentObject var toDosVM: ToDosViewModel
    
    var body: some View {
        Text("Heute")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
        VStack() {
            if toDosVM.toDos.isEmpty {
                Text("Alle To Dos für heute erledigt!")
                    .foregroundColor(.green)
            } else {
                ForEach(toDosVM.toDos, id: \.self) { toDo in
                    HStack {
                        Text("\(toDo.name ?? "")")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray)
                    .cornerRadius(10)
                    .onTapGesture(perform: {
                        toDosVM.updateItem(obj: toDo)
                    })
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.darkGray))
        .cornerRadius(10)
    }
}

struct ToDoToday_Previews: PreviewProvider {
    static var previews: some View {
        ToDoTodayComponent()
    }
}

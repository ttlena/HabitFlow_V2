//
//  ToDoToday.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 20.06.23.
//

import SwiftUI

struct ToDoTodayComponent: View {
    @StateObject var toDosVM: ToDosViewModel
    @State var tappedIndex = -1
    var body: some View {
        Text("Heute")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
        VStack() {
            if toDosVM.toDosToday.isEmpty {
                Text("Heute keine To Dos!")
                    .foregroundColor(.green)
            } else {
                if toDosVM.toDosTodayAllCompleted() {
                    Text("Alle To Dos für heute erledigt!")
                        .foregroundColor(.green)
                } else {
                    ForEach(Array(toDosVM.toDosToday.enumerated()), id: \.offset) { index, toDo in
                        if !toDo.isCompleted {
                           SingleTodayToDo(toDosVM: toDosVM, toDo: toDo)
                        }
                        
                    }
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
        ToDoTodayComponent(toDosVM: ToDosViewModel())
    }
}

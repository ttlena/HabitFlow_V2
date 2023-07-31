//
//  SingleTodayToDo.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 31.07.23.
//

import SwiftUI

struct SingleTodayToDo: View {
    @StateObject var toDosVM: ToDosViewModel
    @StateObject var toDo: ToDo
    @State private var backgroundColor = Color.gray
    
    var body: some View {
        HStack {
            Text("\(toDo.title ?? "")")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(10)
        .onTapGesture(perform: {
            withAnimation(.easeInOut(duration: 0.4)) {
                backgroundColor = Color.green
                toDosVM.updateItem(obj: toDo)
            }
        })
    }
}

struct SingleTodayToDo_Previews: PreviewProvider {
    static var previews: some View {
        SingleTodayToDo(toDosVM: ToDosViewModel(), toDo: ToDo())
    }
}

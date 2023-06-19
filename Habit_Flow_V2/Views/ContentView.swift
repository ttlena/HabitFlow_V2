//
//  ContentView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var toDosVM = ToDosViewModel()
    
    @State private var name = ""
    var body: some View {
        VStack {
            List {
                ForEach(toDosVM.toDos) { toDo in
                    Text(toDo.name ?? "Error")
                }
                .onDelete(perform: toDosVM.deleteItems)
            }
            
            HStack {
                TextField("neues Todo", text:$name)
                Button("Add") {
                    toDosVM.addData(name: name)
                    name = ""
                }
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

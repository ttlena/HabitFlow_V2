//
//  ToDoListView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 30.05.23.
//

import SwiftUI

struct ToDoListView: View {
    
    @EnvironmentObject var toDoListViewModel : ToDoListViewModel
    

    var body: some View {
        List {
            ForEach(toDoListViewModel.items) { item in
                ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            toDoListViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: toDoListViewModel.deleteItem)
            .onMove(perform: toDoListViewModel.moveItem)
        }
        .navigationTitle("ToDo's")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Add", destination: AddView())
            )
    }
    
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoListView()
        }
        .environmentObject(ToDoListViewModel())
        
    }
}

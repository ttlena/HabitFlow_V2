//
//  ToDoListView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 30.05.23.
//

import SwiftUI

struct ToDoListView: View {
    
    @EnvironmentObject var toDoListViewModel : ToDoListViewModel
    @State var showingBottomSheet = false
    

    var body: some View {
        VStack {
            HStack{
                Text("ToDo's")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                Text(String(toDoListViewModel.items.filter{$0.isCompleted == true}.count) + "/" + String(toDoListViewModel.items.count))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .background(Color.purple)
                    .cornerRadius(4)
                    .padding()
                
            }
            if(toDoListViewModel.items.count == 0) {
                Text("Noch keine ToDo's für heute")
            }
           
            
             
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
            
            Button(action: newToDo, label: {
                Text("+ neues ToDo")
            })
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .cornerRadius(32)
            .padding([.horizontal], 100)
            
        }

        
        .frame(maxHeight: .infinity, alignment: .bottom)
            .sheet(isPresented: $showingBottomSheet) {
              AddToDoSheetView()
                    .presentationDetents([.medium, .large])
            }
        
        
        /*
        .navigationTitle("ToDo's")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Add", destination: AddView())
            )
         */
    }
    
    func newToDo() {
        showingBottomSheet.toggle()
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

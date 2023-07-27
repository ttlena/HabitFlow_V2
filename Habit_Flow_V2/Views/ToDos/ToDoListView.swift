//
//  ToDoListView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 30.05.23.
//

import SwiftUI

struct ToDoListView: View {
    
    //@EnvironmentObject var toDoListViewModel : ToDoListViewModel
    @EnvironmentObject var toDosViewModel : ToDosViewModel
    @StateObject var calendarViewModel: CalendarViewModel

    @State var showingBottomSheet = false
    
    
    var body: some View {
        VStack {
            HStack{
                Text("ToDo's")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(toDosViewModel.toDos.filter{$0.isCompleted == true}.count) + " / " + String(toDosViewModel.toDos.count))
                    .padding(10)
                    .padding([.horizontal], 15)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
                
                
                
            }
            .padding([.horizontal], 25)
            WeeklyOverview(calendarViewModel: calendarViewModel)
            
            
            //WeeklyOverview()
            
            if(toDosViewModel.toDos.count == 0) {
                Text("Noch keine ToDo's für heute")
                    .font(.title3)
                    .padding([.top], 100)
            }
            
            
            
            
            
            List {
                ForEach(toDosViewModel.toDos) { item in
                    ListRowView(item: item)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0)) {
                                toDosViewModel.updateItem(obj: item)
                            }
                        }
                }
                .onDelete(perform: toDosViewModel.deleteItems)
                .onMove(perform: toDosViewModel.moveItem)
            }
            .listStyle(InsetListStyle())
            
            PrimaryButton(labelMessage: "neues ToDo", symbol: "plus", action: {
                newToDo()
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .padding([.bottom], 50)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showingBottomSheet) {
            AddToDoSheetView(toDosViewModel:toDosViewModel)
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
            ToDoListView(calendarViewModel: CalendarViewModel())
        }
        .environmentObject(ToDosViewModel())
        
    }
}

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
        let filteredToDos = toDosViewModel.toDos.filter({calendarViewModel.deleteClockComponentFromDate(date: $0.date!) == calendarViewModel.deleteClockComponentFromDate(date: calendarViewModel.pickedDate)})
        
        VStack {
            HStack{
                Text("ToDo's")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(filteredToDos.filter{$0.isCompleted == true}.count) + " / " + String(filteredToDos.count))
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
            
            if(filteredToDos.count == 0) {
                var text = ""
                //heute
                if(calendarViewModel.getDateDayNumber(date: Date()) == calendarViewModel.getDateDayNumber(date: calendarViewModel.pickedDate)) {
                    Text("Noch keine ToDo's für heute")
                        .font(.title3)
                        .padding([.top], 100)
                }else {
                    Text("Noch keine ToDo's für diesen Tag")
                        .font(.title3)
                        .padding([.top], 100)
                }
                    
                
            }
            
            
            
            List {
                ForEach(filteredToDos) { item in
                    ListRowView(item: item)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0)) {
                                toDosViewModel.updateItem(obj: item)
                            }
                        }
                        .swipeActions(edge: .leading) {
                                // Hier fügst du die Aktion hinzu, die bei einer Wischgeste nach rechts ausgeführt werden soll
                                Button(action: {
                                    
                                        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: item.date ?? Date())!
                                        item.date = nextDay
                                        toDosViewModel.updateItem(obj: item)
                                    
                                }) {
                                    Label("Erledigt", systemImage: "arrow.uturn.forward")
                                }
                                .tint(.orange) // Ändere die Farbe der Aktion, wenn gewünscht
                            }
                    
                    
                }
                .onDelete(perform: toDosViewModel.deleteItems)
                .onMove(perform: toDosViewModel.moveItem)
            }
            .listStyle(InsetListStyle())
            
            if(calendarViewModel.deleteClockComponentFromDate(date: calendarViewModel.pickedDate) == calendarViewModel.deleteClockComponentFromDate(date: Date()) ||
                calendarViewModel.deleteClockComponentFromDate(date: calendarViewModel.pickedDate) >
               calendarViewModel.deleteClockComponentFromDate(date: Date())) {
                PrimaryButton(labelMessage: "neues ToDo", symbol: "plus", action: {
                    newToDo()
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            
        }
        .padding([.bottom], 50)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showingBottomSheet) {
            AddToDoSheetView(toDosViewModel:toDosViewModel, pickedDate:calendarViewModel.pickedDate)
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

//
//  ToDoListView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 30.05.23.
//

import SwiftUI


struct ToDoListView: View {
    @EnvironmentObject var toDosViewModel : ToDosViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    
    @State var showingBottomSheet = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    var body: some View {
        
        let filteredToDos = toDosViewModel.updateFilteredToDos(pickedDate: calendarViewModel.pickedDate)
        
        //let filteredToDos = toDosViewModel.toDos.filter({calendarViewModel.deleteClockComponentFromDate(date: $0.date!) == calendarViewModel.deleteClockComponentFromDate(date: calendarViewModel.pickedDate)})
        
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
            
            if(filteredToDos.count == 0) {
                //heute
                if(calendarViewModel.getDateDayNumber(date: Date()) == calendarViewModel.getDateDayNumber(date: calendarViewModel.pickedDate)) {
                    Text("Noch keine ToDo's für heute")
                        .font(.title3)
                        .padding([.top], 100)
                }else {
                    Text("Noch keine ToDo's für " + calendarViewModel.getDateWeekday(date: calendarViewModel.pickedDate))
                        .font(.title3)
                        .padding([.top], 100)
                }
            }
            
            List {
                ForEach(filteredToDos) { item in
                    ListRowView(item: item)
                        .overlay(
                                        Button(action: {
                                            if calendarViewModel.getDateDayNumber(date: item.date ?? Date()) != calendarViewModel.getDateDayNumber(date: Date()) {
                                                alertTitle = "Du kannst dieses ToDo noch nicht abhaken."
                                                showAlert.toggle()
                                            } else {
                                                withAnimation(.linear(duration: 0)) {
                                                    toDosViewModel.updateItem(obj: item)
                                                }
                                            }
                                        }, label: {
                                            // Du kannst hier ein "unsichtbares" Aussehen für den Button definieren
                                            // Z.B. keine Hintergrundfarbe und keine Rahmenlinie
                                            Color.clear
                                        })
                                    )
                        .swipeActions(edge: .leading) {
                            
                            Button(action: {
                                
                                toDosViewModel.shiftToNextDay(obj: item)
                                
                            }) {
                                Label("Erledigt", systemImage: "arrow.uturn.forward")
                            }
                            .tint(.orange) // Ändere die Farbe der Aktion, wenn gewünscht
                        }
                }
                .onDelete(perform: toDosViewModel.deleteItems)
                .onMove(perform: toDosViewModel.moveItem)
                .alert(isPresented: $showAlert, content: getAlert)
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
        .onAppear{UIApplication.shared.applicationIconBadgeNumber = 0}
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
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
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

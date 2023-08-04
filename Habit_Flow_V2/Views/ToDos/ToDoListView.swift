//
//  ToDoListView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 30.05.23.
//

import SwiftUI
import CoreHaptics


struct ToDoListView: View {
    @EnvironmentObject var toDosViewModel : ToDosViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    
    @State var showingBottomSheet = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var currentDate: Date = Date()
    @State private var feedbackGenerator: UIImpactFeedbackGenerator? = nil
    
    var body: some View {
        
        VStack {
            HStack{
                Text("ToDo's")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(toDosViewModel.filteredToDos.filter{$0.isCompleted == true}.count) + " / " + String(toDosViewModel.filteredToDos.count))
                    .padding(10)
                    .padding([.horizontal], 15)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
            }
            .padding([.horizontal], 25)
            
            WeeklyOverview(calendarViewModel: calendarViewModel)
                .onChange(of: calendarViewModel.pickedDate ) { newValue in
                    print("Changing from (oldValue) to (newValue)")
                    filterToDos()
                }
            if(toDosViewModel.filteredToDos.count == 0) {
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
                ForEach(toDosViewModel.filteredToDos) { item in
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
                                                triggerHapticFeedback()
                                            }
                                        }, label: {
                                            Color.clear
                                        })
                                    )
                        .swipeActions(edge: .leading) {
                            
                            Button(action: {
                                
                                toDosViewModel.shiftToNextDay(obj: item)
                                filterToDos()
                            }) {
                                Label("Erledigt", systemImage: "arrow.uturn.forward")
                            }
                            .tint(.orange)
                        }
                }
                .onDelete{ indexSet in
                    toDosViewModel.deleteItems(at: indexSet)
                    filterToDos()
                }
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
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
            currentDate = calendarViewModel.pickedDate
            filterToDos()
        }
        .padding([.bottom], 50)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showingBottomSheet) {
            AddToDoSheetView(toDosViewModel:toDosViewModel, pickedDate:calendarViewModel.pickedDate)
                .presentationDetents([.large])
        }
        
    }
    
    func newToDo() {
        showingBottomSheet.toggle()
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func triggerHapticFeedback() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
    }
    
    private func filterToDos() {
        print("-------filteredTodos called")
        //        self.filteredToDos = toDosViewModel.updateFilteredToDos(pickedDate: calendarViewModel.pickedDate)
        toDosViewModel.filteredToDos = toDosViewModel.updateFilteredToDos(pickedDate: calendarViewModel.pickedDate)
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

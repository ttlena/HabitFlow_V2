import SwiftUI

struct HabitTile: View {
    let habit: Habit
    @StateObject var habitVM: HabitViewModel
    @State private var selectedTab = 0 // To track the currently selected tab
    @State private var showDeleteButton = false // To track when to show the delete button
    @State var showingBottomSheet = false
    @State private var highlighted = false // Variable zum Hervorheben der Kachel
    @State private var color = Color(UIColor.darkGray).opacity(0.8)
    
    var weekdays = ["mo", "di", "mi", "do", "fr", "sa", "so"]
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                HStack {
                    ForEach(habit.weekdays?.sorted { (day1, day2) -> Bool in
                        guard let index1 = weekdays.firstIndex(of: day1),
                              let index2 = weekdays.firstIndex(of: day2) else {
                            return false
                        }
                        return index1 < index2
                    } ?? [], id: \.self) { weekday in
                        ZStack(alignment: .bottom) {
                            Text(weekday.capitalized)
                                .font(.system(size: 15))
                                .lineLimit(1)
                                .foregroundColor(.orange)
                        }
                    }
                }
                if selectedTab == 0 {
                    Text("Woche")
                } else if selectedTab == 1 {
                    Text("Monat")
                } else if selectedTab == 2 {
                    Text("Jahr")
                }
                
                Divider()
                    .frame(height: 0.3)
                    .font(.system(size: 17))
                    .background(Color.white)
                
            }
            TabView(selection: $selectedTab) {
                VStack (spacing: 3) {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 22))
                        
                    }
                    CircularProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                    Text("\(habit.current)/\(habit.goal)")
                        .padding(.bottom, 5)
                    
                }
                .tag(0)
                
                VStack {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 22))

                    }
                    CircularMonthProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                    Text("\(habit.currentInMonth)/\(habit.goalInMonth)")
                        .padding(.bottom, 5)
                }
                .tag(1)
                
                VStack {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 22))

                    }
                    CircularYearProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                    Text("\(habit.currentInYear)/\(habit.goalInYear)")
                        .padding(.bottom, 5)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(selectedTab == index ? Color.orange : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 6)
            .padding(.bottom, 6)
            
            
        }
        .background(color)
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .overlay(
            Group {
                if showDeleteButton {
                    Button(action: {
                        habitVM.deleteHabit(habit: habit)
                        showDeleteButton = false
                        
                        print("moin")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.red)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(.top, -126)
                            .padding(.trailing, 3)
                            .onTapGesture {
                                habitVM.deleteHabit(habit: habit)
                                showDeleteButton = false
                                
                            }
                        
                    }
                    
                }
            }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
        )
        .onTapGesture {
            showDeleteButton = false
            highlighted = true
            
            editHabit()
            
        }
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: .infinity, pressing: { isPressing in
            if isPressing {
                color =  Color(UIColor.systemGray2).opacity(0.8)
            } else {
                color =  Color(UIColor.darkGray).opacity(0.8)
                
            }
        }, perform: {
            showDeleteButton = true
            print("test")
        })
        .sheet(isPresented: $showingBottomSheet) {
            EditHabitSheetView(habitVM: habitVM, habit: habit)
                .presentationDetents([.medium, .large])
        }
        
    }
    
    
    func editHabit() {
        if !habitVM.plusButtonClicked {
            
            color =  Color(UIColor.systemGray2).opacity(0.8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                highlighted = false
                color =  Color(UIColor.darkGray).opacity(0.8)
                
            }
            habitVM.setEditHabit(habit: habit)
            showingBottomSheet.toggle()
            
            
        }
        habitVM.plusButtonClicked = false
    }
}


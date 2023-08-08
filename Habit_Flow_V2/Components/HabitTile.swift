import SwiftUI

struct HabitTile: View {
    let habit: Habit
    @StateObject var habitVM: HabitViewModel
    @State private var selectedTab = 0 // To track the currently selected tab
    @State private var showDeleteButton = false // To track when to show the delete button
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                VStack {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                    }
                    .padding()
                    CircularProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                    Text("\(habit.current)/\(habit.goal)")
                        .padding(.bottom, 5)
                }
                .tag(0)
                
                VStack {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                    }
                    .padding()
                    CircularMonthProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                    Text("\(habit.currentInMonth)/\(habit.goalInMonth)")
                        .padding(.bottom, 5)
                }
                .tag(1)
                
                VStack {
                    HStack {
                        Text(habit.title ?? "Unknown")
                            .foregroundColor(.white)
                    }
                    .padding()
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
        .background(Color(UIColor.darkGray).opacity(0.8))
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
                                print("hallo")
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
        }
        .onLongPressGesture{
            showDeleteButton = true
            print("test")
        }
    }
}


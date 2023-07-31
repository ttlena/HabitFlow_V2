import SwiftUI

struct HabitTile: View {
    let habit: Habit
    @StateObject var habitVM: HabitViewModel
    @State private var selectedTab = 0 // To track the currently selected tab
    
    var body: some View {
        //GeometryReader { geometry in
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
                CircularProgressView(progress: habit.progress, habitVM: habitVM, habit: habit)
                Text("\(habit.current)/\(habit.goal)")
                    .padding(.bottom, 5)
            }
            .tag(1)
            
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
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        //.frame(width: geometry.size.width, height: geometry.size.height) // Set the size of TabView to the available space
        
        .background(Color(UIColor.darkGray).opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal, 10) // Padding nur für rechts und links
        .padding(.vertical, 5) // Z    }
        
    }
}

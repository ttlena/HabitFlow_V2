//
//  HomeView.swift
//  HabitFlow
//
//  Created by Lena Ngo on 12.05.23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var habitViewModel: HabitViewModel
    @StateObject var toDosViewModel: ToDosViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    @StateObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Hallo " + (userViewModel.user.userName ??  "Du") + "!")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding([.top, .bottom, .trailing], 20.0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                        
                        if let imageData = userViewModel.user.profilePicture{
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                }
                        }else {
                            Image("defaultProfilePicture")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                        .frame(height: 40)
                    WeeklyOverview(calendarViewModel: calendarViewModel)
                    Spacer()
                        .frame(height: 25)
                    ToDoTodayComponent(toDosVM: toDosViewModel)
                    Spacer()
                        .frame(height: 25)
                    DailyHabitsComponent(habitsVM: habitViewModel)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            }
            .background(.black)
        }
        .background(.black)
        .clipped()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(habitViewModel: HabitViewModel(), toDosViewModel: ToDosViewModel(), calendarViewModel: CalendarViewModel(), userViewModel: UserViewModel())
    }
}

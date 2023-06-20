//
//  HomeView.swift
//  HabitFlow
//
//  Created by Lena Ngo on 12.05.23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Text("Hallo Jens!")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding([.top, .bottom, .trailing], 20.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    Image("ProfilePic")
                }
                Spacer()
                    .frame(height: 40)
                WeeklyOverview()
                Spacer()
                    .frame(height: 25)
                ToDoTodayComponent()
                Spacer()
                    .frame(height: 25)
                DailyHabitsComponent()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
        }
        .background(.black)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

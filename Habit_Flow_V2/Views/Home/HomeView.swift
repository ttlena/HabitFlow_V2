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
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20) {
                        ForEach(0..<7) { idx in
                            VStack {
                                Text("Day")
                                Text("\(idx + 1)")
                            }
                            .padding()
                            .background(.gray)
                            .cornerRadius(10)
                        }
                    }
                }
                Spacer()
                    .frame(height: 25)
                Text("Heute")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                VStack() {
                    ForEach(0..<3) { idx in
                        HStack {
                            Text("Todo \(idx + 1)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.gray)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.darkGray))
                .cornerRadius(10)
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

//
//  TestView.swift
//  Habit_Flow_V2
//
//  Created by Florian Bohn on 30.07.23.
//

import SwiftUI

struct TestView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            VStack1()
                .tag(1)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Tab 1")
                }

            VStack2()
                .tag(2)
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Tab 2")
                }
        }
        .tabViewStyle(.page) 
    }
}

struct VStack1: View {
    var body: some View {
        VStack {
            Text("View Stack 1")
                .font(.title)
                .padding()

            // Add your content for VStack1
        }
    }
}

struct VStack2: View {
    var body: some View {
        VStack {
            Text("View Stack 2")
                .font(.title)
                .padding()

            // Add your content for VStack2
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

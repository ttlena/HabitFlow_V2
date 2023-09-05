//
//  ContentView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataController = DataController.shared
    @StateObject var userViewModel = UserViewModel()
    var body: some View {
        if(userViewModel.user.firstStart) {
            IntroView(userViewModel: userViewModel)
        }else {
            NavigationBar()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
        
    }
    
    func toggle() {
        userViewModel.toggleFirstStarted()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

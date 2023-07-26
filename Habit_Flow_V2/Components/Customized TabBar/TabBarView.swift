//
//  TabBarView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 26.07.23.
//

import SwiftUI

struct TabBarView: View {
    var tabBarItems: [TabItemData]
    @Binding var selectedIndex: Int

    var height: CGFloat = 60
    var width: CGFloat = UIScreen.main.bounds.width - 32
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(tabBarItems.indices, id: \.self) { index in
                Button {
                    self.selectedIndex = index
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(item: tabBarItems[index], isSelected: isSelected)
                }
                Spacer()
            }
        }
        .frame(width: .infinity, height: height)
        .background(Color.black)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(tabBarItems: [
            TabItemData(image: "home_icon", selectedImage: "home_selected", title: "Home"),
            TabItemData(image: "calendar_icon", selectedImage: "calendar_selected", title: "Kalender"),
            TabItemData(image: "todos_icon", selectedImage: "todos_selected", title: "To Do's"),
            TabItemData(image: "habits_icon", selectedImage: "habits_selected", title: "Habits")
        ], selectedIndex: .constant(0))
    }
}

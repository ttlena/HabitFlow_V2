//
//  TabItemView.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 26.07.23.
//

import SwiftUI

struct TabItemView: View {
    let item: TabItemData
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(isSelected ? item.selectedImage : item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 30, maxHeight: 30)
            Text(item.title)
                .foregroundColor(isSelected ? .white : .gray)
                .font(.system(size: 12))
        }
        .frame(maxWidth: 60, maxHeight: 40)
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(item: TabItemData(image: "HomeIcon", selectedImage: "home_selected", title: "Home"), isSelected: true)
    }
}

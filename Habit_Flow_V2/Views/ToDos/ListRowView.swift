//
//  ListRowView.swift
//  HabitFlow
//
//  Created by Marc Bachmann on 31.05.23.
//

import SwiftUI

struct ListRowView: View {
    
    @StateObject var item: ToDo
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ? .orange : .white)
            Text(item.title ?? "")
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct ListRowView_Previews: PreviewProvider {
    
    static var item1 = ToDo()
    static var item2 = ToDo()
    
    static var previews: some View {
        Group {
            ListRowView(item: item1)
            ListRowView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}

//
//  PageView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            
            Image("\(page.imageUrl)")
                .resizable()
                .scaledToFit()
                .cornerRadius(30)
                .padding()
            
            
            Text(page.name)
                .font(.title)
                .bold()
                
            Text(page.description)
                .font(.subheadline)
                .frame(width: 300)
            
  
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(page: Page.samplePage)
    }
}

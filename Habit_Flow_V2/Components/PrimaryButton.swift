//
//  PrimaryButton.swift
//  HabitFlow
//
//  Created by Florian Bohn on 30.05.23.
//

import SwiftUI

struct PrimaryButton: View {
    var labelMessage: String
    var symbol: String
    var action: () -> Void

    
    init(labelMessage: String, symbol: String, action: @escaping () -> Void) {
        self.labelMessage = labelMessage
        self.symbol = symbol
        self.action = action
        
    }
    
    var body: some View {
        Button(action: {
            print("Button tapped!")
        }) {
            HStack {
                Image(systemName: symbol)
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(Color.white)
                Text(labelMessage)
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(Color.white)
            }
            .padding()
            .foregroundColor(.black)
            .background(Color.orange)
            .cornerRadius(32)
        }
    }
    
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(labelMessage: "neuer Eintrag", symbol: "plus", action: {
            print("printed")
        })
    }}

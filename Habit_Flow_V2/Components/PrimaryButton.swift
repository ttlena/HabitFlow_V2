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
        VStack {
            Button(action: {
                action()
            }) {
                HStack {
                    Image(systemName: symbol)
                    Text(labelMessage)
                }
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(32)
            }
        }
        .frame(maxWidth: 200)
        .padding([.horizontal], 100)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(labelMessage: "neuer Eintrag", symbol: "plus", action: {
            print("printed")
        })
    }}

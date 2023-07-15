//
//  CircularProgressView.swift
//  HabitFlow
//
//  Created by Lena Ngo on 31.05.23.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        ZStack() {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 15
                )
            Circle()
                .trim(from: 0, to: progress) // 1
                .stroke(
                    Color.orange,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            Circle()
                .foregroundColor(.clear)
            Image("Plus")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .padding(20)
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.4)
    }
}

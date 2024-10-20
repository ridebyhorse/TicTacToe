//
//  LaunchScreen.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    @State private var textIndex = 0
    @State private var isTextVisible = false
    let textArray = Array(Resources.Text.ticTacToe)  
 
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Image("Launch1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 0.8 : 1)
                        .offset(y: isAnimating ? 0 : -300)
                    
                    Image("Launch2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 0.8 : 1)
                        .offset(y: isAnimating ? 0 : -300)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .onAppear {
                withAnimation(
                    .spring(response: 1, dampingFraction: 0.5)
                ) {
                    isAnimating = true
                }
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<textArray.count, id: \.self) { index in
                        Text(String(textArray[index]))
                            .font(.mainTitle)
                            .foregroundColor(.basicBlack)
                            .opacity(textIndex >= index ? 1 : 0)
                            .animation(.easeIn(duration: 0.04), value: textIndex)
                            .padding(.horizontal, -1)
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if textIndex < textArray.count {
                            textIndex += 1
                        } else {
                            timer.invalidate()
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    LaunchScreen()
}

//
//  PlayerSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI

struct PlayerSquareView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 104, height: 104)
                .foregroundColor(Color("basicLightBlue"))
            VStack(spacing: 10){
                Image("crossPink")
                    .resizable()
                    .frame(width: 54, height: 54)
                Text("Player")
                    .font(.basicSubtitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("basicBlack"))
            }
        }
    }
}

#Preview {
    PlayerSquareView()
}

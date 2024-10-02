//
//  GameSelectView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//
import SwiftUI

struct GameSelectView: View {
    @ObservedObject var viewModel: GameSelectViewModel
    @State var selectedPlayer: String? = "single"
    @State var selectedType: String? = "Hard"
    @State var selectedSymbol: String = "cross"
    @State var secondPlayerSymbol: String = "circle"
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)

            VStack {
                toolBar
                
                Spacer()

                VStack(spacing: 20) {
                    Text("\(viewModel.playerOneName)  Player Name")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.basicBlack)
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            selectPlayerSymbol("cross")
                        }) {
                            Image("crossPink")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .padding()
                                .background(selectedSymbol == "cross" ? Color.basicBackground : Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 0.2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedSymbol == "cross" ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                                )
                        }

                        Button(action: {
                            selectPlayerSymbol("circle")
                        }) {
                            Image("circlePurple")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .padding()
                                .background(selectedSymbol == "circle" ? Color.basicBackground : Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 0.2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedSymbol == "circle" ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                    
                    VStack {
                        Text("\(viewModel.playerTwoName)  Player Name")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.basicBlack)
                        
                        HStack(spacing: 30) {
                            Image("crossPink")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .padding()
                                .background(secondPlayerSymbol == "cross" ? Color.basicBackground : Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 0.2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(secondPlayerSymbol == "cross" ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                                )
                            
                            Image("circlePurple")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .padding()
                                .background(secondPlayerSymbol == "circle" ? Color.basicBackground : Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 0.2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(secondPlayerSymbol == "circle" ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
                .frame(width: 285, height: 330)
                .background(.white)
                .cornerRadius(30)
                .shadow(radius: 5)

                Spacer()
            }
        
        }

        VStack {
            BasicButton(
                styleType: .primary,
                title: Resources.Text.letsPlay,
                tapHandler: { viewModel.startGame() }
            )
            .padding()
        }
    }
    
    private var toolBar: some View {
        ToolBarView(
        showRightButton: true,
        rightButtonAction: viewModel.showSettings,
        title: ""
        )
        .frame(height: 44)
    }
    
    func selectPlayerSymbol(_ symbol: String) {
        selectedSymbol = symbol
        secondPlayerSymbol = (symbol == "cross") ? "circle" : "cross"
        viewModel.updateSymbol(symbol)
    }
}

#Preview {
    GameSelectView(viewModel: GameSelectViewModel(coordinator: Coordinator()))
}

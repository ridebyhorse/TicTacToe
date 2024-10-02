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
                Spacer().frame(height: 80)
                Grid {
                    Spacer()
                    Spacer()
                    Text("Select Game")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.basicBlack)
                    
                    GridRow {
                        VStack(alignment: .center) {
                            Spacer()
                            
                            Button(action: {
                                selectedType = "Hard"
                                viewModel.updateGameMode("Hard")
                            }) {
                                HStack {
                                    Text("Hard")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.basicBlack)
                                }
                            }
                            .frame(width: 245, height: 60)
                            .background(selectedType == "Hard" ? Color.basicBlue : Color.basicLightBlue)
                            .cornerRadius(35)
                            .shadow(radius: 2)
                            .padding(.top)
                            
                            Button(action: {
                                selectedType = "Standard"
                            }) {
                                HStack {
                                    Text("Standard")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.basicBlack)
                                }
                            }
                            .frame(width: 245, height: 60)
                            .background(selectedType == "Standard" ? Color.basicBlue : Color.basicLightBlue)
                            .cornerRadius(35)
                            .shadow(radius: 2)
                            .padding(.top)
                            
                            Button(action: {
                                selectedType = "Easy"
                            }) {
                                HStack {
                                    Text("Easy")
                                        .font(.title3)
                                        .foregroundColor(Color.basicBlack)
                                }
                            }
                            .frame(width: 245, height: 60)
                            .background(selectedType == "Easy" ? Color.basicBlue : Color.basicLightBlue)
                            .cornerRadius(35)
                            .shadow(radius: 2)
                            .padding(.top)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .frame(width: 285, height: 330)
                .background(.white)
                .cornerRadius(30)
                .shadow(radius: 5)
                
                Spacer().frame(height: 25)
                
                VStack(spacing: 20) {
                    Text("\(viewModel.playerOneName)  Player Name")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.basicBlack)
                    
                    HStack(spacing: 30) {
                        VStack {
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
                        }
                        
                        VStack {
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
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(viewModel.playerTwoName)  player Name")
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
            
            VStack {
                HStack {
                    Button(action: {
                    
                    }) {
                        Image("backIcon")
                            .resizable()
                            .frame(width: 38, height: 36)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                       
                    }) {
                        Image("settingsIcon")
                            .resizable()
                            .frame(width: 38, height: 36)
                    }
                    .padding()
                }
                Spacer()
                    .padding()
            }
        }
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

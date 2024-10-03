import SwiftUI

import SwiftUI

struct GameSelectView: View {
    @ObservedObject var viewModel: GameSelectViewModel
    
    @State private var selectedGameMode: GameMode = .singlePlayer 
    @State private var showingAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                ToolBarView(
                    showRightButton: true,
                    rightButtonAction: viewModel.showSettings,
                    title: ""
                )
                .frame(height: 44)
                .background(Color.white)
                .zIndex(1)
                
                Spacer()
                gameSelectionCard
                Spacer()
            }
        }
    }
    
    // MARK: - Game Selection Card
    private var gameSelectionCard: some View {
        VStack {
            Text("Select Game")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.basicBlack)
                .padding(10)
            
            VStack(alignment: .center) {
                Spacer()
                
                // Выбор между одиночной игрой и игрой на двоих
                gameModeButton(icon: "singlePlayerIcon", title: "Single Player", isSelected: selectedGameMode == .singlePlayer) {
                    selectedGameMode = .singlePlayer
                }
                
                if selectedGameMode == .singlePlayer {
                    playerNameTextField(placeholder: "Enter your name", text: $viewModel.singlePlayerName, onSubmit: startSinglePlayerGame)
                        .alert("Please enter your name", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                }
                
                gameModeButton(icon: "twoPlayersIcon", title: "Two Players", isSelected: selectedGameMode == .twoPlayers) {
                    selectedGameMode = .twoPlayers
                }
                
                if selectedGameMode == .twoPlayers {
                    playerNameTextField(placeholder: "Player 1 Name", text: $viewModel.playerOneName)
                    playerNameTextField(placeholder: "Player 2 Name", text: $viewModel.playerTwoName)
                }
                
                nextButton
                
            }
        }
        .padding()
        .frame(width: 285, height: cardHeight)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 5)
    }
    
    // MARK: - Buttons
    private func gameModeButton(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(icon)
                Text(title)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .basicBlack)
            }
        }
        .frame(width: 245, height: 70)
        .background(isSelected ? Color.basicBlue : Color.basicLightBlue)
        .cornerRadius(35)
        .shadow(radius: 2)
        .padding(10)
    }
    
    private var nextButton: some View {
        Button(action: {
            viewModel.setGameMode(selectedGameMode)
            viewModel.startGame()
        }) {
            Text("Next")
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .frame(width: 245, height: 70)
        .background(Color.basicBlue)
        .cornerRadius(35)
        .shadow(radius: 2)
        .padding(20)
    }
    
    // MARK: - Player Name TextField
    private func playerNameTextField(placeholder: String, text: Binding<String>, onSubmit: @escaping () -> Void = {}) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(Color.basicLightBlue)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.basicBlack.opacity(0.08), lineWidth: 2)
            )
            .padding(.horizontal)
            .foregroundColor(.gray)
            .font(.system(size: 18, weight: .medium))
            .multilineTextAlignment(.center)
            .onSubmit(onSubmit)
    }
    
    // MARK: - Computed Properties
    private var cardHeight: CGFloat {
        switch selectedGameMode {
        case .singlePlayer: return 450
        case .twoPlayers: return 514
        }
    }
    
    // MARK: - Private Methods
    private func startSinglePlayerGame() {
        if viewModel.singlePlayerName.isEmpty {
            showingAlert = true
        } else {
            viewModel.playerTwoName = "AI"  // Если одиночная игра, то второй игрок - AI
            dismissKeyboard()
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    GameSelectView(viewModel: GameSelectViewModel(coordinator: Coordinator()))
}

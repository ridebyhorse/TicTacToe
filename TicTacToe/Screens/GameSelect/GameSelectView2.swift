import SwiftUI

struct GameSelectView2: View {
    @ObservedObject var viewModel: GameSelectViewModel

    @State private var selectedPlayer: String? = "single"
    @State private var showingAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
           
            
            VStack {
                ToolBarView(showRightButton: true,rightButtonAction:
                                viewModel.showSettings, title: "")
                
                gameSelectionCard
                
                
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
                
                gameModeButton(icon: "singlePlayerIcon", title: "Single Player", isSelected: selectedPlayer == "single") {
                    selectedPlayer = "single"
                }
                
                if selectedPlayer == "single" {
                    playerNameTextField(placeholder: "Enter your name", text: $viewModel.singlePlayerName, onSubmit: startSinglePlayerGame)
                        .alert("Please enter your name", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                }

                gameModeButton(icon: "twoPlayersIcon", title: "Two Players", isSelected: selectedPlayer == "two") {
                    selectedPlayer = "two"
                }
                
                if selectedPlayer == "two" {
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
            selectedPlayer = "leaderboard"
        }) {
            Text("Next")
                .font(.title3)
                .foregroundColor(selectedPlayer == "leaderboard" ? .white : .basicBlack)
                .fontWeight(.semibold)
        }
        .frame(width: 245, height: 70)
        .background(selectedPlayer == "leaderboard" ? Color.basicBlue : Color.basicLightBlue)
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
        switch selectedPlayer {
        case "single": return 450
        case "two": return 514
        default: return 425
        }
    }
    
    // MARK: - Private Methods
    private func startSinglePlayerGame() {
        if viewModel.singlePlayerName.isEmpty {
            showingAlert = true
        } else {
            viewModel.playerTwoName = "AI"
            dismissKeyboard()
            // Start the single-player game here
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    GameSelectView2(viewModel: GameSelectViewModel(coordinator: Coordinator()))
}

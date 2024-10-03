import SwiftUI

struct GameSelectView2: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedPlayer: String? = "single"
    @State private var showingAlert: Bool = false

    let singlePlayerIcon = "singlePlayerIcon"
    let twoPlayerIcon = "twoPlayersIcon"
    let selectGameText = "Select Game"
    let singlePlayerText = "Single Player"
    let single = "single"

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea()
            VStack {
                Spacer()
                toolBar
                Spacer().padding(.bottom, 20)
                gameSelectionCard
                Spacer().padding(.bottom, 100)
            }
        }
    }

    // MARK: - ToolBar
    private var toolBar: some View {
        ToolBarView(
            showRightButton: true,
            rightButtonAction: {
                viewModel.showSettings()
            },
            title: ""
        )
        .frame(height: 44)
    }

    // MARK: - Game Selection Card
    private var gameSelectionCard: some View {
        VStack {
            Text(selectGameText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.basicBlack)
                .padding(10)

            VStack(alignment: .center) {
                Spacer()

                gameModeButton(icon: singlePlayerIcon, title: singlePlayerText, isSelected: selectedPlayer == single) {
                    selectedPlayer = single
                }

                if selectedPlayer == single {
                    playerNameTextField(placeholder: "Enter your name", text: $viewModel.singlePlayerName, onSubmit: startSinglePlayerGame)
                        .alert("Please enter your name", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                }

                gameModeButton(icon: twoPlayerIcon, title: "Two Players", isSelected: selectedPlayer == "two") {
                    selectedPlayer = "two"
                }

                if selectedPlayer == "two" {
                    twoPlayerNameFields
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

    // MARK: - Game Mode Button
    private func gameModeButton(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(icon)
                Text(title)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .basicBlack)
                    .fontWeight(.semibold)
            }
        }
        .frame(width: 245, height: 70)
        .background(isSelected ? Color.basicBlue : Color.basicLightBlue)
        .cornerRadius(35)
        .shadow(radius: 2)
        .padding(10)
    }

    // MARK: - Next Button
    private var nextButton: some View {
        Button(action: {
            viewModel.saveSettings()
            viewModel.startGame()
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
            .onChange(of: text.wrappedValue) { _ in
                viewModel.saveSettings()
            }
            .onSubmit(onSubmit)
    }

    // MARK: - Two Player Name Fields
    private var twoPlayerNameFields: some View {
        VStack {
            playerNameTextField(placeholder: "Player 1 Name", text: $viewModel.playerOneName)
            playerNameTextField(placeholder: "Player 2 Name", text: $viewModel.playerTwoName)
        }
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
            viewModel.playerTwoName = ""
            dismissKeyboard()
            // Start single-player game logic here
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    GameSelectView2(viewModel: SettingsViewModel(coordinator: Coordinator()))
}

import SwiftUI

@main
struct TicTacToeApp: App {
    //MARK: - Properties
    @State private var isLoading: Bool = true
    @StateObject private var settingsViewModel = SettingsViewModel(coordinator: Coordinator())
    private let coordinatorView = CoordinatorView()
    
//MARK: - Main Code
    var body: some Scene {
        WindowGroup {
            contentView
                .environmentObject(settingsViewModel)
                .onAppear {
                    print(settingsViewModel.hasAppliedTheme)
                   // for not throwing to LaunchScreen After ThemeChange
                    if settingsViewModel.hasAppliedTheme {
                        coordinatorView.coordinator.updateNavigationState(action: .showSettings)
                    }
                }
        }
    }
    
    //MARK: -  For making .preferredColorSheme Usable
    private var contentView: some View {
        Group {
            if isLoading {
                LaunchScreen()
                    .preferredColorScheme(settingsViewModel.userTheme.colorScheme)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                coordinatorView
                    .preferredColorScheme(settingsViewModel.userTheme.colorScheme)
            }
        }
    }
}

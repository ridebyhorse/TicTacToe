import SwiftUI

@main
struct TicTacToeApp: App {
    //MARK: - Properties
    @State private var isLoading: Bool = true
    @StateObject private var settingsViewModel = SettingsViewModel(coordinator: Coordinator())
//MARK: - Main Code
    var body: some Scene {
        WindowGroup {
            
            contentView
                .environmentObject(settingsViewModel)
                .onAppear {
                   // for not throwing to LaunchScreen After ThemeChange
                    if !settingsViewModel.hasAppliedTheme {
                        settingsViewModel.applyTheme()
                    }
                }
        }
    }
    
    //MARK: -  For making .preferredColorSheme Usable
    private var contentView: some View {
        Group {
            if isLoading {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                CoordinatorView()
                    .preferredColorScheme(settingsViewModel.userTheme.colorScheme)
            }
        }
       // .preferredColorScheme(settingsViewModel.userTheme.colorScheme)
    }
}

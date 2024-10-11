//
//  ThemeChangeView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/10/24.
//

import SwiftUI
import Foundation

struct ThemeChangeView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @AppStorage("user_theme") private var userTheme: Theme = .systemDefaut

    // MARK: - Animation
    @Namespace private var animation
    // MARK: - ViewProperty
    @State private var circleOffset: CGSize
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        let isDark = viewModel.userTheme == .dark
        self._circleOffset = .init(initialValue: CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Circle()
                .fill(viewModel.userTheme.color(viewModel.userTheme.colorScheme ?? .light))
                .frame(width: 150, height: 150)
                
                .mask {
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                        }
                        
                }
            
            Text("Choose Mode")
                .foregroundColor(viewModel.userTheme.textColor)
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical)
                        .frame(width: 100)
                        .background {
                            ZStack {
                                if viewModel.userTheme == theme {
                                    Capsule()
                                        .fill(.white)
                                        .matchedGeometryEffect(id: "ACTIVEAB", in: animation)
                                }
                            }
                            .animation(.snappy, value: viewModel.userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            viewModel.userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(.white)
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        
        .onAppear {
            updateCircleOffset(for: viewModel.userTheme)
        }
        .onChange(of: viewModel.userTheme) { newValue in
            withAnimation(.bouncy) {
                updateCircleOffset(for: newValue)
            }
        }
    }
    private func updateCircleOffset(for theme: Theme) {
        let isDark = theme == .dark
        circleOffset = CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150)
    }
}
#Preview {
    ThemeChangeView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}

//MARK: - Theme
enum Theme: String, CaseIterable{
   case systemDefaut = "default"
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme:ColorScheme) -> Color{
        switch self {
            case .systemDefaut:
            return scheme == .dark ? .white: .basicBackground
        case .light:
            return .white
        case .dark:
            return .dark
        }
    }
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefaut:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    var textColor: Color {
        switch self {
        case .systemDefaut:
            return .primary
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
}

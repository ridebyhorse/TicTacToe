import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    @State private var textIndex = 0
    @State private var isTextVisible = false
    let textArray = Array("Tic-Tac-Toe")
    
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
                    .spring(response: 1, dampingFraction: 0.5).delay(0.2)
                ) {
                    isAnimating = true
                }
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<textArray.count, id: \.self) { index in
                        Text(String(textArray[index]))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.basicBlack)
                            .opacity(isTextVisible && textIndex >= index ? 1 : 0)
                            .animation(.easeIn(duration: 0.1).delay(0.05 * Double(index)), value: isTextVisible)
                    }
                }
                .onAppear {
                    isTextVisible = true
                    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
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

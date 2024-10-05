import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack{
                    Image("tictac2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 2.5 : 3.7)
                        .opacity(0.8)
                }
                
                HStack{
                    Image("tictac")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 3 : 4)
                        .padding(.top,350)
                }
                .padding(30)
            }
            .padding(.horizontal, 150)
            .padding(.bottom, 80)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
                ) {
                    isAnimating.toggle()
                }
            }
            
            Spacer()
            
            
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.basicBackground)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.launch)
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchScreen()
}

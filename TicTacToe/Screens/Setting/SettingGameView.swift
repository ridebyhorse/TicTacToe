//
//  SettingGameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct SettingGameView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: SettingsViewModel
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let imagePairs = [
         ("crossPink", "circlePurple"),
         ("crossYellow", "circleGreen"),
         ("crossFilledPurple", "circleFilledPurple"),
         ("starPurple", "heartPink"),
         ("cake", "icecream"),
         ("burger", "fries")
     ]
    @State private var selectedIndex: Int? = 0
    @State private var turnTime = false
    @State private var selectedDate = Date()
    
    var body : some View {

    NavigationView {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        viewModel.dissmisSettings()
                    }) {
                        HStack {
                            Image("backIcon")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
                HStack{
                    VStack {
                        Text("Turn on the time")
                            .font(.headline)
                            .foregroundColor(Color.basicBlack)
                    }
                    .padding()
                    
                    Toggle("", isOn: $turnTime)
                        .toggleStyle(SwitchToggleStyle(tint: Color.basicBlue))
                        .labelsHidden()
                }
                .frame(width: 270, height: 60)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Spacer()
                
                Spacer()
                
                    HStack {
                        
                            Text("Time for game")
                                .font(.headline)
                                .foregroundColor(Color.basicBlack)
                                .padding()
                        if turnTime {
                            DatePicker("Select Time", selection: $selectedDate, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                            VStack {
                                
                            }
                        }
                        
                    }
                
                .frame(width: 270, height: 60)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(0..<6) { index in
                        VStack {
                            HStack {
                                Image(imagePairs[index].0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Image(imagePairs[index].1)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            .padding(.bottom, 20)
                            
                            Button(action: {
                                selectedIndex = index
                            }) {
                                Text(selectedIndex == index ? "Picked" : "Choose")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(selectedIndex == index ? Color.basicBlue : Color.basicLightBlue)
                                    .cornerRadius(20)
                                    .foregroundColor(selectedIndex == index ? .white : Color.basicBlack)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarHidden(true)
    }
}
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}

//
//  TimerView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 07.10.2024.
//

import SwiftUI

struct TimerView: View {
    let title: String
    let subTitle: String
    @Binding var isTimerEnabled: Bool
    @Binding var timerSeconds: Int

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Toggle(isOn: $isTimerEnabled) {
                    Text(title)
                        .titleText(size: 20)
                }
                .tint(.basicBlue)
               
            }
            .padding()
            .background(LightBlueBackgroundView {
                // Контент внутри
            })
            .cornerRadius(30)

            if isTimerEnabled {
                VStack {
                    Text(subTitle)
                        .subtitleText(size: 20)

                    HStack {
                        Text("\(formattedTime(seconds: timerSeconds))")
                            .subtitleText(size: 20)

                        Stepper("", value: $timerSeconds, in: 2...300, step: 1)
                            .onChange(of: timerSeconds) { newValue in
                                timerSeconds = newValue
                            }
                    }
                }
                .padding()
                .background(LightBlueBackgroundView {
                    // Контент внутри
                })
                .cornerRadius(30)
            }
        }
    }

    private func formattedTime(seconds: Int) -> String {
        let minute = seconds / 60
        let seconds = seconds % 60
        return "\(minute) min. \(seconds) sec."
    }
}



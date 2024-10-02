//
//  SettingPickerView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct SettingPickerView<Value: RawRepresentable & CaseIterable & Hashable>: View where Value.RawValue == String {
    
    @Binding var selectedValue: Value
    let title: String
    
    var body: some View {
            Picker(title, selection: $selectedValue) {
                ForEach(Value.allCases.map { $0 }, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .styledFrame(title)
    }
}


private extension View {
    func styledFrame(_ title: String) -> some View {
        VStack {
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(Color.basicBlack)
            
            self
            Spacer()
        }
        .frame(width: 270, height: 90)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 5)
    }
}

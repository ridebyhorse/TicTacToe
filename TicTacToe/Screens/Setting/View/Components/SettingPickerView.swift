//
//  SettingPickerView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct SettingPickerView<Value: RawRepresentable & CaseIterable & Hashable>: View where Value.RawValue == String {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @Binding var selectedValue: Value
    let title: String
    
    var body: some View {
            Picker(title, selection: $selectedValue) {
                ForEach(Value.allCases.map { $0 }, id: \.self) { value in
                    Text(value.rawValue.localized(language)).tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .styledFrame(title)
            .frame(alignment: .trailing)
    }
}


private extension View {
    func styledFrame(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.basicBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            self
        }
        .frame(width: 300, height: 60)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
    }
}

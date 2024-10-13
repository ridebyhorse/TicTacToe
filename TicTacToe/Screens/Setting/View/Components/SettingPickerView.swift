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
    @Binding var isExpanded: Bool
    let title: String

    var backgroundCornerRadius: CGFloat = 30

    private var filteredValues: [Value] {
        Value.allCases.filter { "\($0)" != "none" }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
         
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.basicBlack)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Text(selectedValue.rawValue.localized(language))
                        .font(.headline)
                        .foregroundColor(.basicBlack)
                        .padding(.trailing, 20)
                }
                .frame(minHeight: 70)
                .background {
                    RoundedRectangle(cornerRadius: backgroundCornerRadius, style: .continuous)
                        .fill(.basicLightBlue)
                }
            }
            
            if isExpanded {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(filteredValues, id: \.self) { value in
                        Button {
                            withAnimation {
                                selectedValue = value
                                isExpanded = false
                            }
                        } label: {
                            VStack {
                                Divider()
                                    .background(Color.secondaryPurple)
                                Text(value.rawValue.localized(language))
                                    .font(.headline)
                                    .foregroundColor(.basicBlack)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 40)
                                    .padding(.horizontal, 30)
                            }
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: backgroundCornerRadius, style: .continuous)
                        .fill(.basicLightBlue)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: backgroundCornerRadius, style: .continuous)
                .fill(.basicLightBlue)
        }
    }
}

#Preview {
    SettingPickerView(
        selectedValue: .constant(ExampleEnum.option1),
        isExpanded: .constant(false),
        title: "Choose Option"
    )
}

// Пример enum для демонстрации
enum ExampleEnum: String, CaseIterable, Hashable {
    case option1 = "Option 1"
    case option2 = "Option 2"
    case option3 = "Option 3"
}

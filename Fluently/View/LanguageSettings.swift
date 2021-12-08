//
//  LanguageSettings.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/25/21.
//

import SwiftUI

struct LanguageSettings: View {
    
    //: MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    @State var languages = [
        LanguageRowView(languageName: "Spanish"),
        LanguageRowView(languageName: "English"),
        LanguageRowView(languageName: "German"),
        LanguageRowView(languageName: "French"),
        LanguageRowView(languageName: "Russian"),
        LanguageRowView(languageName: "Japanese")
    ]
    
    var body: some View {
        NavigationView {
            List(languages, id: \.id) { language in
                Text(language.languageName)
                    .onTapGesture {
                        selectedLanguage = language.languageName
                        presentationMode.wrappedValue.dismiss()
                        print(language)
                    }
            }
            .padding(.horizontal)
                
            .navigationBarTitle(Text("Choose A Language"), displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color.secondary)
            })
        }
    }
}

struct LanguageRowView: View {
    var languageName: String
    var id = UUID()
    var body: some View {
        VStack {
            Text(languageName)
                .font(.system(.headline))
                .foregroundColor(Color.secondary)
        }
    }
}

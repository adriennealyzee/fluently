//
//  SettingsView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/6/21.
//

import SwiftUI

struct SettingsView: View {
    //: MARK: - Properties
    @State var language: Bool = false
    
    
    //: MARK: - Body
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                GroupBox(
                    label: SectionHeaderView(labelText: "Language Settings", labelImage: "")
                ) {
                    Divider().padding(.vertical, 4)
                    
                    
                    Toggle(isOn: $language) {
                        Text("Placeholder".uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    
                }.padding()
            }
            
        }.navigationTitle("Fluently Settings")
    }
}



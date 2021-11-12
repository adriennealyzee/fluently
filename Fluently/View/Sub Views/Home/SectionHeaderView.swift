//
//  SettingsSectionView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/5/21.
//

import SwiftUI

struct SectionHeaderView: View {
    var labelText: String
    var labelImage: String?
    var body: some View {
        HStack {
            Text(labelText.uppercased())
            Spacer()
            Image(systemName: labelImage!)
        }
    }
}


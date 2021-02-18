//
//  FluentlyApp.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI
//import Firebase
import MLKit


@main
struct FluentlyApp: App {
    var translator: Translator?

    init() {
//        FirebaseApp.configure()
        print("initing")
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//
//  FluentlyApp.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI

@main
struct FluentlyApp: App {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
    
}

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
    var translator: Translator? = nil

    init() {
//        FirebaseApp.configure()
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        self.translator = Translator.translator(options: options)
        
        let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true )
        print("starting download")
        self.translator!.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                print("error downloading", error)
                return
            }
            print("Model downloaded successfully")
        }
        
        // App Group
        let sharedDefault = UserDefaults(suiteName: "group.fluently.appgroup")!
        sharedDefault.set("secret code", forKey: "keyForMySharableData")
        let mySharableData = sharedDefault.object(forKey: "keyForMySharableData") as! String
        
        print("mySharableData value: ", mySharableData)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WordUpdate.notificationReceived(notification:)), name: Notification.Name("wordUpdated"), object: nil)
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class WordUpdate {

    @objc func notificationReceived(notification: Notification) {
        print("notification received!")
        // post a notification to translationReceived
        
    }
}

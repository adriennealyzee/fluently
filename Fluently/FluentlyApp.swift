//
//  FluentlyApp.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI
//import MLKit

@main
struct FluentlyApp: App {
    
//     It will be best to use FileManager, UserDefaults work best for small pieces of data.
//     let sharedContainer = UserDefaults(suiteName: "group.fluently.appgroup")
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    

    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                ContentView()
            } else {
                ContentView()
            }
        }
    }
    
//     init() {
//         print("initing")
//         Model.shared.downloadTranslator()
//
//         let userInput = sharedContainer!.object(forKey: "keyboardInput") as! String
//         Model.shared.updateTranslationString(text: userInput)
//     }

}

//class Model{
//
//    static let shared = Model()
//    var translator: Translator? = nil
//    // let sharedContainer = UserDefaults(suiteName: "group.fluently.appgroup")
//
//    private init(){
//    }
//
//    func downloadTranslator(){
//        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
//        self.translator = Translator.translator(options: options)
//        let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true )
//
//        print("starting download")
//        self.translator!.downloadModelIfNeeded(with: conditions) { error in
//            guard error == nil else {
//                print("error downloading", error)
//                return
//            }
//            print("Model downloaded successfully")
//        }
//    }
//
//    func updateTranslationString(text:String){
//        self.translator!.translate(text) { translatedText, error in
//            guard error == nil, let translatedText = translatedText else { return }
//            // self.sharedContainer!.setValue(translatedText, forKey: "translationString")
//
//            // let printTranslated = self.sharedContainer!.object(forKey: "translationString") as! String
//            // print("printTranslated", printTranslated)
//        }
//    }
//
//}

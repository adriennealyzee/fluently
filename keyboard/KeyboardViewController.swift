//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import UIKit
import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI
import Combine
import MLKit
//import Firebase


class KeyboardViewController: KeyboardInputViewController {
    
//    initialize NSFileCoordinator
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
    }
    
//    var translator: Translator? = nil
//
//    convenience init() {
//        self.init(nibName:nil, bundle: nil)
//        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
//        self.translator = Translator.translator(options: options)
//
//        let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true )
//        print("starting download")
//        self.translator!.downloadModelIfNeeded(with: conditions) { error in
//            guard error == nil else {
//                print("error downloading", error)
//                return
//            }
//            print("Model downloaded successfully")
//        }
//    }
    let sharedDefault = UserDefaults(suiteName: "group.fluently.appgroup")!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("TRANSLATED TEXT 0")
        setup(with: keyboardView)
        context.actionHandler = DemoKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = DemoKeyboardAppearanceProvider()
        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            leftSpaceAction: .keyboardType(.emojis),
            rightSpaceAction: .keyboardType(.images))
        
        let mySharableData = sharedDefault.object(forKey: "keyForMySharableData") as! String
        
        print("mySharableData value: ", mySharableData)
        
//        ML Kit
//        self.translator = Translator.translator(options: options)
//        let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true )
//        print("starting download")
//
//        self.translator!.downloadModelIfNeeded(with: conditions) { error in
//            guard error == nil else {
//                print("error downloading", error)
//                return
//            }
//            print("Model downloaded successfully")
//        }
//        print("TRANSLATED TEXT 1")
//        translator.translate("how are you?") { translatedText, error in
//            guard error == nil, let translatedText = translatedText else { return }
//        }
//        let example = translateText(text: "how are you")
//        print("TRANSLATED TEXT 2", example)
    }
    
//  MARK: - MLKit
    func translateText(text: String) {
//        translator!.translate(text) { translatedText, error in
//            guard error == nil, let translatedText = translatedText else { return }
//            print("TRANSLATED TEXT 2", translatedText)
////            self.keyboardView.previewLabel.text = translatedText
////            pass translatedText to AutoCompleteSuggestion provider
//        }
    }

    
    
    // MARK: - Properties
    
    private var cancellables = [AnyCancellable]()
    
    private let toastContext = KeyboardToastContext()
    
    private var keyboardView: some View {
        KeyboardView(controller: self)
            .environmentObject(autocompleteContext)
            .environmentObject(toastContext)
    }
    
    
    // MARK: - Autocomplete
    
    private lazy var autocompleteContext = ObservableAutocompleteContext()
    
    private lazy var autocompleteProvider = DemoAutocompleteSuggestionProvider()
    
    override func performAutocomplete() {
        guard let word = textDocumentProxy.currentWord else { return resetAutocomplete() }
        autocompleteProvider.autocompleteSuggestions(for: word) { [weak self] result in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let result): self?.autocompleteContext.suggestions = result
            }
        }
        
//        sharedDefault.set(word, forKey: "word")
//        NotificationCenter.default.post(name: Notification.Name("wordUpdated"), object: nil)
        
        // update a file in shared app group
        
        
        
    }
    
//    @objc func notificationReceived2(notification: Notification) {
//        print("notification received 2!")
//        // post a notification
//
//    }
    
    override func resetAutocomplete() {
        autocompleteContext.suggestions = []
    }
}

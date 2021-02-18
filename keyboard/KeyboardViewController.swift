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
import Firebase


class KeyboardViewController: KeyboardInputViewController {
    
    //    MARK: - MLKit Properties
    let conditions = ModelDownloadConditions(
        allowsCellularAccess: false,
        allowsBackgroundDownloading: true
    )

    var options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        
    var translator: Translator? = nil
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TRANSLATED TEXT 0")
        setup(with: keyboardView)
        context.actionHandler = DemoKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = DemoKeyboardAppearanceProvider()
        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            leftSpaceAction: .keyboardType(.emojis),
            rightSpaceAction: .keyboardType(.images))
        
//        ML Kit
        
        self.translator = Translator.translator(options: self.options)
        translator!.downloadModelIfNeeded(with: conditions) { error in
            if error == nil {
                print(error ?? "Error downloading!")
                return
            } else {
                print("Downloaded model successfully")
            }
        }
//        print("TRANSLATED TEXT 1")
//        translator.translate("how are you?") { translatedText, error in
//            guard error == nil, let translatedText = translatedText else { return }
//        }
//        let example = translateText(text: "how are you")
//        print("TRANSLATED TEXT 2", example)
    }
    
//  MARK: - MLKit
    func translateText(text: String) {
        translator!.translate(text) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }
            print("TRANSLATED TEXT 2", translatedText)
//            self.keyboardView.previewLabel.text = translatedText
//            pass translatedText to AutoCompleteSuggestion provider
        }
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
    }
    
    override func resetAutocomplete() {
        autocompleteContext.suggestions = []
    }
}

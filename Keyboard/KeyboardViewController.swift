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

extension UserDefaults {
    @objc dynamic var userValue:String? {
        return string(forKey: "keyboardInput")
    }
    @objc dynamic var translationString:String? {
        return string(forKey: "translationString")
    }
}

class KeyboardViewController: KeyboardInputViewController {
    
    var userInputSubscriber: AnyCancellable?
    var translationStringSubscriber: AnyCancellable?
    let sharedContainer = UserDefaults(suiteName: "group.fluently.appgroup")
    static let shared = Model()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: keyboardView)
        context.actionHandler = DemoKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = DemoKeyboardAppearanceProvider()
        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            leftSpaceAction: .keyboardType(.emojis),
            rightSpaceAction: .keyboardType(.images))
        
//        Model.shared.downloadTranslator()
        
        // Add observers
        userInputSubscriber = sharedContainer!.publisher(for: \.userValue).sink() {
                print("userInputSubscriber keyboardInput changed", $0)
            }
        
        translationStringSubscriber = sharedContainer!.publisher(for: \.translationString).sink() {
                print("translationStringSubscriber translationString changed", $0)
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
        
        // update a file in shared app group
        UserDefaults(suiteName: "group.fluently.appgroup")!.set(textDocumentProxy.currentWord, forKey: "keyboardInput")
        
    }
    
    func spacePress(){
        print("spacePress")
    }

    
    override func resetAutocomplete() {
        autocompleteContext.suggestions = []
    }
}



class Model{
    
    static let shared = Model()
    var translator: Translator? = nil
    
    init(){
        print("initing Model")
    }
    
    func downloadTranslator(){
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
    }
    
    func updateTranslationString(text:String){
        self.translator!.translate(text) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }
            print("translatedText", translatedText)
        }
    }
    
}

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

class KeyboardViewController: KeyboardInputViewController {

    // MARK: Properties
    var translator: Translator!
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        lookForSomething()
        handleDownloadDelete(TranslateLanguage.spanish)
        //print(isLanguageDownloaded(TranslateLanguage.english))
        //print(isLanguageDownloaded(TranslateLanguage.spanish))
        setTranslator(inputLanguage: TranslateLanguage.english, outputLanguage: TranslateLanguage.spanish)
        super.viewDidLoad()
        setup(with: keyboardView)
        context.actionHandler = DemoKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext)
        context.keyboardAppearanceProvider = DemoKeyboardAppearanceProvider()
        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            leftSpaceAction: .keyboardType(.emojis),
            rightSpaceAction: .keyboardType(.images))
    }

    
    // MARK: - Properties
    
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

extension KeyboardViewController {
    func lookForSomething() {
        
        let stringFilename = "MyString.txt"
        // let stringToSave = "12"
        
        let fileManager = FileManager()
        let sharedContainerDirectory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.fluently.appgroup")!
        let sharedLanguagesDirectory = sharedContainerDirectory.appendingPathComponent("Languages", isDirectory: true)
        let stringFilePath = sharedLanguagesDirectory.appendingPathComponent(stringFilename, isDirectory: false)
        
        // Checking if there is something inside the shared containers directory
        do {
            let contentOfSharedContainer = try fileManager.contentsOfDirectory(atPath: sharedContainerDirectory.path)
            print(contentOfSharedContainer)
            let contentOfLanguageDirectory = try fileManager.contentsOfDirectory(atPath: sharedLanguagesDirectory.path)
            print(contentOfLanguageDirectory)
            let contentInFile = try String(contentsOf: stringFilePath, encoding: .utf8)
            print(contentInFile)
            
        } catch let error {
            print("Error looking for something")
            print(error)
        }
        
        
    }
    
    func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool {
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        
        return modelManager.isModelDownloaded(model)
    }
    
    func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
        return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    func handleDownloadDelete(_ language: TranslateLanguage) {
        // english is downloaded by default
        if language == .english { return }
        
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        let languageName = Locale.current.localizedString(forLanguageCode: language.rawValue)!
        
        if modelManager.isModelDownloaded(model) {
            // Model is already downloaded.
            print("Deleting \(languageName)")
            modelManager.deleteDownloadedModel(model) { error in
                print("Deleted \(languageName)")
            }
        } else {
            // Model isn't downloaded.
            print("Downloading \(languageName)")
            let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
            modelManager.download(model, conditions: conditions)
            print("Downloaded \(languageName)")
        }
    }
    
    /// This function sets the translator property.
    ///
    /// Depending on the provided ```inputLanguage``` and ```outputLanguage``` a specific translator
    /// is going to be generated and set it to the  ```self.translator``` property.
    ///
    /// - Parameter inputLanguage: The language we want to translate from.
    /// - Parameter outputLanguage: The language we want to translate to.
    func setTranslator(inputLanguage: TranslateLanguage, outputLanguage: TranslateLanguage) {
        let options = TranslatorOptions(sourceLanguage: inputLanguage, targetLanguage: outputLanguage)
        self.translator = Translator.translator(options: options)
        self.translate()
    }
    
    /// This function will translate the content of ```self.text``` using the ```self.translator```.
    func translate() {
        let translatorForDownloading = self.translator!
        
        translatorForDownloading.downloadModelIfNeeded { error in
            // This closure will run after trying to download the translator.
            
            guard error == nil else {
                // Error handling in case it didn't download.
                
                print("Failed to ensure model download with error \(error!)")
                return
            }
            
            if translatorForDownloading == self.translator {
                // After making sure the translator hasn't change yet this will run.
                
                translatorForDownloading.translate("Deep Space") { result, error in
                    // This closure will run with the result or and error.
                    
                    guard error == nil else {
                        // Error handling in case it didn't translated.
                        
                        print("Failed to translate with error \(error!)")
                        return
                    }
                    if translatorForDownloading == self.translator {
                        // The translation was successfull.
                        print(result!)
                    }
                }
            }
        }
    }
}

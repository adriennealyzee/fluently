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
    
    func spacePress(){
        print("spacePress")
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
}

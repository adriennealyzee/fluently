//
//  ContentView.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI
import Combine
import MLKit

// let sharedContainer = UserDefaults(suiteName: "group.fluently.appgroup")

//extension UserDefaults {
//    @objc dynamic var keyboardInput:String? {
//        return string(forKey: "keyboardInput")
//    }
//}

struct ContentView: View {
    
    @State private var text: String = ""
    @State var translator: Translator!
    
    lazy var locale = Locale.current
    lazy var allLanguages = TranslateLanguage.allLanguages().sorted {
        // Sort alphabetically.
        return locale.localizedString(forLanguageCode: $0.rawValue)! < locale.localizedString(forLanguageCode: $1.rawValue)!
    }
    
    // if sharedContainer["keyboardInput"] is changed:
    //    @State var cancellable: AnyCancellable? = sharedContainer!.publisher(for: \.keyboardInput).sink() {
    //            print("subscriber keyboardInput: ", $0)
    //            let userInput = sharedContainer!.object(forKey: "keyboardInput") as! String
    //            Model.shared.updateTranslationString(text: userInput)
    //    }
    
    var body: some View {
        TextField("type something...", text: $text)
            .padding()
            .onChange(of: text) { value in
                print("Value: \(value)")
                setTranslator(inputLanguage: TranslateLanguage.english, outputLanguage: TranslateLanguage.spanish)
            }
    }
}



extension ContentView {
    
    /// This function returns a remote model of the given language.
    ///
    /// The remote model that is return is yet to be downloaded. It represents the one we want to
    /// download from the servers.
    ///
    /// - Parameter forLanguage: The given language for the remote model.
    func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
        return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    /// This function decided whether deletes or download models.
    ///
    /// After giving the function a language it will check whether or not
    /// its has been downloaded the model for that language. Depending on
    /// the answer it will download the model or delete it.
    ///
    /// - Parameter language: The language to be deleted or downloaded.
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
    
    /// This functions return whether or not a model for specifc language is already downloaded.
    ///
    /// - Parameter language: The language of the model to be check.
    func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool {
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        
        return modelManager.isModelDownloaded(model)
    }
    
    /// This function list all the models that are already downloaded.
    func listDownloadedModels() {
        let downloadedModels = ModelManager.modelManager().downloadedTranslateModels
        
        let message = "Downloaded models: " +
            downloadedModels.map({ model in
                Locale.current.localizedString(forLanguageCode: model.language.rawValue)!
            }).joined(separator: ", ")
        
        print(message)
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
                
                translatorForDownloading.translate(self.text) { result, error in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

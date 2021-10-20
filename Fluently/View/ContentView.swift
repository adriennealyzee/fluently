//
//  ContentView.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI
import Combine
import MLKit

struct ContentView: View {
    
    @State private var text: String = ""
    @State private var translation: String = "Translated text goes here."
    @State var translator: Translator!
    @State private var showingSettings: Bool = false
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    
    lazy var locale = Locale.current
    lazy var allLanguages = TranslateLanguage.allLanguages().sorted {
        // Sort alphabetically.
        return locale.localizedString(forLanguageCode: $0.rawValue)! < locale.localizedString(forLanguageCode: $1.rawValue)!
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    //: MARK: - Test Section
                    GroupBox(label: SectionHeaderView(labelText: "Test the Translator", labelImage: "square.and.pencil")) {
                        Divider().padding(.vertical, 4)
                        
                        Text("\(translation)")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        TextField("Type something here...", text: $text)
                            .padding()
                            .multilineTextAlignment(.center)
                            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                            .onChange(of: text) { value in
                                print("Value: \(value)")
                                setTranslator(inputLanguage: TranslateLanguage.english, outputLanguage: TranslateLanguage.spanish)
                                
                                saveSomething()
                                // lookForSomething()
                            }
                            

                    }.padding()
                    
                    //: MARK: - Settings Section
                    GroupBox(
                        label: SectionHeaderView(labelText: "Settings", labelImage: "gear")
                    ) {
                        Divider().padding(.vertical, 4)
                        
                            HStack {
                                NavigationLink(destination: SettingsView()) {
                                             
                                          
                                    Text("Application Settings")
                                        .padding(.vertical, 8)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                            
                        
                    }.padding()
                    
                    
                    
                    //: MARK: - Restart Onboarding Section
                    GroupBox(
                        label: SectionHeaderView(labelText: "Customization", labelImage: "restart.circle")
                    ) {
                        Divider().padding(.vertical, 4)
                        
                        Text("If you wish, you can restart the application by turning the switch to the on position. By doing this, it will restart the onboarding process and you will see the welcome screen once again.")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Toggle(isOn: $isOnboarding) {
                            if isOnboarding {
                                Text("Restarted".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.green)
                            } else {
                                Text("Restart".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                        
                    }.padding()
                    
                }
                
            }//: Scroll
            .navigationTitle("Fluently")
            
        }
    }
}

extension ContentView {
    
    func saveSomething() {
        
        let stringFilename = "MyString.txt"
        let stringToSave = "12"
        
        let fileManager = FileManager()
        let sharedContainerDirectory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.fluently.appgroup")!
        let sharedLanguagesDirectory = sharedContainerDirectory.appendingPathComponent("Languages", isDirectory: true)
        let stringFilePath = sharedLanguagesDirectory.appendingPathComponent(stringFilename, isDirectory: false)
        
        // Create Language Directory
        do {
            try fileManager.createDirectory(at: sharedLanguagesDirectory, withIntermediateDirectories: true, attributes: nil)
            
        } catch let error {
            print("Error creating language directory")
            print(error)
        }
        
        // Writing a file to memory
        let data: Data? = stringToSave.data(using: .utf8)
        do {
            try data!.write(to: stringFilePath, options: .atomic)
            
        } catch let error {
            print("Error writing the file to memory")
            print(error)
        }
        
//        // Checking if there is something inside the shared containers directory
//        do {
//            let contentOfSharedContainer = try fileManager.contentsOfDirectory(atPath: sharedContainerDirectory.path)
//            print(contentOfSharedContainer)
//
//        } catch let error {
//            print("Error writing the file to memory")
//            print(error)
//        }
    }
    
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
    
    func deleteSomething() {
        
        // let stringFilename = "MyString.txt"
        // let stringToSave = "12"
        
        let fileManager = FileManager()
        let sharedContainerDirectory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.fluently.appgroup")!
        let sharedLanguagesDirectory = sharedContainerDirectory.appendingPathComponent("Languages", isDirectory: true)
        // let stringFilePath = sharedLanguagesDirectory.appendingPathComponent(stringFilename, isDirectory: false)
        
        // Deletes files from previous location
        do {
            try fileManager.removeItem(at: sharedLanguagesDirectory)

        } catch let error {
            print("Error deleting the file")
            print(error)
        }
    }
    
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
                        self.translation = result!
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

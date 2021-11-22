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
    @State private var translation: String = "type something below to translate..."
    @State var translator: Translator!
    @State private var showingSettings: Bool = false
    @State private var showingOnboarding: Bool = false
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
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
                            }
                    }.padding(.horizontal)
                    
                    //: MARK: - Settings Section
                    GroupBox(
                        label: SectionHeaderView(labelText: "Settings", labelImage: "gear")
                    ) {
                        Divider().padding(.vertical, 4)
                        Button(action: {
                            showingSettings = true
                            
                            
                        }) {
                            HStack {
                                
                                Text("Selected Language")
                                    .padding(.vertical, 8)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.secondary)
                                
                                Spacer()
                                
                                if let unwrappedValue = selectedLanguage {
                                    Text(unwrappedValue)
                                        .foregroundColor(Color.secondary)
                                } else {
                                    Text("Choose a Language")
                                        .foregroundColor(Color.secondary)
                                }
                            }
                            .sheet(isPresented: $showingSettings) {
                                LanguageSettings()
                            }
                            
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                        
                        
                    }.padding(.horizontal)
                    
                    
                    
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
                        
                        Button(action: {
                            showingOnboarding = true
                            
                        }, label: {
                            
                            Text("Restart".uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(Color.secondary)
                            
                        })
                        .sheet(isPresented: $showingOnboarding) {
                            OnboardingView()
                        }
                        
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    }.padding(.horizontal)
                }.navigationTitle("Fluently")
                
            }
        }
    }
}

extension ContentView {
    
    /// This function returns a remote model of the given language.
    ///
    /// The remote model that will return is yet to be downloaded. It represents the one we want to
    /// download from the servers.
    ///
    /// - Parameter forLanguage: The given language for the remote model.
    func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
        return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    /// This function decides whether to delete or download models.
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

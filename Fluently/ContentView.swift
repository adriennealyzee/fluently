//
//  ContentView.swift
//  Fluently
//
//  Created by Adrienne Alyzee on 1/13/21.
//

import SwiftUI
import Combine

let sharedContainer = UserDefaults(suiteName: "group.fluently.appgroup")

extension UserDefaults {
    @objc dynamic var keyboardInput:String? {
        return string(forKey: "keyboardInput")
    }
}

struct ContentView: View {
    
    @State private var text: String = "yo"
    
    // if sharedContainer["keyboardInput"] is changed:
    @State var cancellable: AnyCancellable? = sharedContainer!.publisher(for: \.keyboardInput).sink() {
            print("subscriber keyboardInput: ", $0)
            let userInput = sharedContainer!.object(forKey: "keyboardInput") as! String
            Model.shared.updateTranslationString(text: userInput)
    }
    
    var body: some View {
        TextField("type something...", text: $text)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

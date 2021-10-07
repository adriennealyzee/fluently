//
//  SettingsCardView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct SettingsCardView: View {
    //: MARK: - Properties
    @State private var isAnimating: Bool = false
    
    
    //: MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                //: TITLE
                Text("Installation Guide")
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                    .padding(.top)
                
                
                //: IMAGE
                Image("sample")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 1), radius: 2, x: 2, y: 2)
                
                //: STEPS
                Group {
                    HStack{
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Go to Settings")
                            .font(.headline)
                    }
                    
                    
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Tap: General")
                            .font(.headline)
                    }
                  
                    
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Tap: Keyboards")
                            .font(.headline)
                    }
                   
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Tap: Add new Keyboard")
                            .font(.headline)
                    }
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Add fluently and enable full access")
                            .font(.headline)
                    }
                 
                    SettingsButtonView()
                        
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        .background(LinearGradient(gradient: Gradient(colors: [Color("colorBlue"), Color("colorDarkBlue")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}


//: MARK: - Preview
struct SettingsCardView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCardView()
    }
}
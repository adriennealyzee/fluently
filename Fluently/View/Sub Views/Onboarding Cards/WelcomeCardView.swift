//
//  WelcomeCardView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct WelcomeCardView: View {
    
    //: MARK: - Properties
    
    @State private var isAnimating: Bool = false
    
    
    
    //: MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                
                
                //: IMAGE
                Image("sample")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 1), radius: 2, x: 2, y: 2)
                //: TITLE
                Text("Welcome")
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)

                //: HEADLINE
                Text("Fluently is a passive way to learn new languages. We are so happy to have you here, and we know you'll love it. Swipe right to get started!")
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
                
                
                
            }//: VSTACK
        }//: ZSTACK
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }//: animation
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        .background(LinearGradient(gradient: Gradient(colors: [Color("colorGreen"), Color("colorGreen")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}


//: MARK: - Preview
struct WelcomeCardView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeCardView()
    }
}

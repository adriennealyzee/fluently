//
//  CompletedCardView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct CompletedCardView: View {
    //: MARK: - Properties
    @State private var isAnimating: Bool = false
    
    
    //:MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                Text("🎉")
                    .font(.system(size: 100))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                    .scaleEffect(isAnimating ? 1.0 : 0.005)
                    
                
                
                Text("Fantastic, You have completed the onboarding process. Please select the start button to continue. ")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
                    .padding(.bottom, 75)
                    
                
                StartButtonView()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        .background(LinearGradient(gradient: Gradient(colors: [Color("colorGray"), Color("colorGray")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}


//: MARK: - Preview
struct CompletedCardView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedCardView()
    }
}

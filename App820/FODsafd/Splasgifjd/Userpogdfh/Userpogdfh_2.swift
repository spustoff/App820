//
//  Userpogdfh_2.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI
import StoreKit

struct Userpogdfh_2: View {
    var body: some View {
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Image("users_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("Rate our app in the AppStore".uppercased())
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: {
                    
                    Userpogdfh_3()
                        .navigationBarBackButtonHidden()
                    
                }, label: {
                    
                    Text("NEXT")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary")))
                        .padding()
                })
            }
            .ignoresSafeArea(.all, edges: .top)
        }
        .onAppear {
            
            SKStoreReviewController.requestReview()
        }
    }
}

#Preview {
    Userpogdfh_2()
}

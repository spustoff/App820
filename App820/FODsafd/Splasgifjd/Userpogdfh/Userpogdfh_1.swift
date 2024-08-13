//
//  Userpogdfh_1.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI

struct Userpogdfh_1: View {
    var body: some View {
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Image("users_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("Discover all the money-making opportunities".uppercased())
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: {
                    
                    Userpogdfh_2()
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
    }
}

#Preview {
    Userpogdfh_1()
}

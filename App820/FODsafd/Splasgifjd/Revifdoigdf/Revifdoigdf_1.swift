//
//  Revifdoigdf_1.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI

struct Revifdoigdf_1: View {
    var body: some View {
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Image("reviewers_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("Create your own professional strategies and tips".uppercased())
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: {
                    
                    Revifdoigdf_2()
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
    Revifdoigdf_1()
}

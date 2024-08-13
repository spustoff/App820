//
//  Revifdoigdf_2.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI

struct Revifdoigdf_2: View {
    
    @AppStorage("status") var status: Bool = false
    
    var body: some View {
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Image("reviewers_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("We have written for you only the best rules for games".uppercased())
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    
                    status = true
                    
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
    Revifdoigdf_2()
}

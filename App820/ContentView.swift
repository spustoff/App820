//
//  ContentView.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @State var isDead: Bool = true
    
    @AppStorage("status") var status: Bool = false
    @AppStorage("isRequested") var isRequested: Bool = false
    
    init() {
        
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            if isFetched == false {
                
                Lodajfd()
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    if status {
                    
                        WebSystem()
                        
                    } else {
                        
                        Revifdoigdf_1()
                    }
                    
                } else if isBlock == false {
                    
                    if status {
                        
                        WebSystem()
                        
                    } else {
                        
                        Userpogdfh_1()
                    }
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        guard isRequested == false else {
            
            self.isFetched = true
            
            return
        }
        
        let networkService = NetworkService()
        let deviceData = DeviceInfo.collectData()
        
        networkService.sendRequest(endpoint: deviceData) { result in
            
            isRequested = true
            
            switch result {
                
            case .success(let success):
                
                self.isBlock = success
                self.isFetched = true
                
            case .failure(_):
                
                self.isBlock = self.isDead
                self.isFetched = true
            }
        }
    }
}

#Preview {
    ContentView()
}

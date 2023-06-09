//
//  AppStorageDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/09.
//

import SwiftUI

struct AppStorageDemo: View {
    
    //@State var currentUserName: String?
    @AppStorage("name") var currentUserName: String?//Use AppStorage when variable is in a view, otherwise use UserDefaults
    
    var body: some View {
        VStack(spacing: 20){
            Text(currentUserName ?? "Add Name Here")
            
            if let name = currentUserName{
                Text(name)
            }
            
            Button("Save".uppercased()){
                let name: String = "Nick"
                currentUserName = name
                //UserDefaults.standard.set(name, forKey: "name")
            }
        }
//        .onAppear(){
//            currentUserName = UserDefaults.standard.string(forKey: "name")
//        }
            
        
    }
}

struct AppStorageDemo_Previews: PreviewProvider {
    static var previews: some View {
        AppStorageDemo()
    }
}

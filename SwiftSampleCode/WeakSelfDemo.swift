//
//  WeakSelfDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/09.
//

import SwiftUI

struct WeakSelfDemo: View {
    
    @AppStorage("count") var count: Int?
    
    init(){
        count = 0
    }
    
    var body: some View {
        NavigationView{
            NavigationLink("Navigate", destination: WeakSelfSecondScreen())
                .navigationTitle("Screen 1")
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            , alignment: .topTrailing
        )
    }
    
    
}

struct WeakSelfSecondScreen: View {
    
    @StateObject var vm  = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        Text("Second View")
            .font(.largeTitle)
            .foregroundColor(.red)
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject{
    
    @Published var data: String? = nil
    
    init(){
        print("INITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit{
        print("DEINITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData(){
        
//        DispatchQueue.global().async {
//            self.data = "New Data!!!"
//        }   download data from internet...
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 500){
            [weak self] in
            self?.data = "New Data!!"
        }
        
        
    }
}

struct WeakSelfDemo_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfDemo()
    }
}

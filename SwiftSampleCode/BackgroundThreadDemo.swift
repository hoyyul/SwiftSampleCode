//
//  BackgroundThreadDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/08.
//

import SwiftUI

class BackgroundThreadViewModel: ObservableObject{
    
    @Published var dataArray: [String] = []
    
    func fetchData(){
        
        DispatchQueue.global(qos: .background).async{//jump to another thread
            let newData = self.downloadDaTa()
            
            print("Check 1: \(Thread.isMainThread)")
            print("Check 1: \(Thread.current)")
            
            DispatchQueue.main.async {//before any change on UI, must go back to main thread
                self.dataArray = newData
                print("Check 2: \(Thread.isMainThread)")
                print("Check 2: \(Thread.current)")
            }
        }
    }
    
    private func downloadDaTa() -> [String]{
        var data: [String] = []
        for x in 0..<100{
            data.append("\(x)")
        }
        
        return data
    }
}

struct BackgroundThreadDemo: View {
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        VStack {
            Text("Load Data")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .onTapGesture {
                    vm.fetchData()
                }
            
            ForEach(vm.dataArray, id: \.self) { item in
                Text(item)
                    .font(.headline)
            }
        }
    }
}

struct BackgroundThreadDemo_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundThreadDemo()
    }
}

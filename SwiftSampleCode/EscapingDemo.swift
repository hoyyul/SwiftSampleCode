//
//  EscapingDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/10.
//

import SwiftUI

class EscapingViewModel: ObservableObject{
    
    @Published var text: String = "Hello"
    
    func getData(){
        
        // it's ok to deintialize this class
//        downloadData3 {[weak self] (returnedData) in
//            self?.text = returnedData
//        }
        
        downloadData4 { [weak self] (returnedResult) in
            self?.text = returnedResult.data
        }
    }
    
    func downloadData() -> String {
        return "New data!"
    }
    
    func downloadData2(completionHandler: (_ data: String)->Void){// returnedData = Data = "New data";_ is a function name for external use; completion called when function is done
        completionHandler("New data!")
    }
    
    func downloadData3(completionHandler: @escaping (_ data: String)->Void){//simulating get data from database; escaping key word allows asynchronous
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            completionHandler("New data!")
        }
    }
    
    func downloadData4(completionHandler: @escaping (DownloadResult)->Void){// more readable
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            let result = DownloadResult(data: "New data!")
            completionHandler(result)
        }
    }
}

struct DownloadResult{
    let data: String
}

struct EscapingDemo: View {
    
    @StateObject var vm = EscapingViewModel()
    
    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}

struct EscapingDemo_Previews: PreviewProvider {
    static var previews: some View {
        EscapingDemo()
    }
}

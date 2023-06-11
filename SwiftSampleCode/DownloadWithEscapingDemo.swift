//
//  DownloadWithEscapingDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/11.
//

import SwiftUI

struct PostModel: Identifiable, Codable{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithEscapingViewModel: ObservableObject{
    
    @Published var posts: [PostModel] = []
    
    init(){
        
    }
    
    func getPosts(){
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData{
                guard let newPost = try? JSONDecoder().decode([PostModel].self, from: data) else{ return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.posts = newPost// comeback to main thread to update ui
                }
            }else{
                print("No data returned")
            }
        }
        
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {//when downloading something asychronous and take time to return, use escaping
        
        URLSession.shared.dataTask(with: url) { data, response, error in//dataTask goes to background thread by default to download data
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else {
                print("Error downloading data")
                completionHandler(nil)//to tell the function is finished
                return
            }
            
            completionHandler(data)
            
            
        }.resume()
        
        
    }
    
}

struct DownloadWithEscapingDemo: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List{
            ForEach(vm.posts){ post in//post is identifiable
                VStack{
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct DownloadWithEscapingDemo_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapingDemo()
    }
}

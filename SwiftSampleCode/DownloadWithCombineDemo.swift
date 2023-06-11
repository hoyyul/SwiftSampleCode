//
//  DownloadWithCombine.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/12.
//

import SwiftUI
import Combine

struct PostModel2: Identifiable, Codable{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithCombineViewModel: ObservableObject{
    
    @Published var posts: [PostModel2] = []
    var cancellables = Set<AnyCancellable>()
    
    
    init(){
        getPosts()
    }
    
    func getPosts(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        //Combine discussion:
        /*
        //1. create the publisher
        //2. subcribe publisher on background thread
        //3. recieve on main thread
        //4. tryMap (check data)
        //5. decode data into PostModel
        //6. put the item into app(sink)
        //7. store(cancel) subscription if needed
         */
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PostModel2].self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")//this line tells there is no error thrown
            } receiveValue: { [weak self](returnedPosts) in
                self?.posts = returnedPosts
            }.store(in: &cancellables)
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
}

struct DownloadWithCombineDemo: View {
    
    @StateObject var vm = DownloadWithCombineViewModel()
    
    var body: some View {
        List{
            ForEach(vm.posts){ post in
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

struct DownloadWithCombine_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombineDemo()
    }
}

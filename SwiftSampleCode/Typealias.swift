//
//  Typealias.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/10.
//

import SwiftUI

struct MovieModel{
    let title: String
    let director: String
    let count: Int
}

typealias TVModel = MovieModel//create a new name for class


struct Typealias: View {
    
    //@State var item: MovieModel = MovieModel(title: "Title", director: "Joe", count: 5)
    @State var item: TVModel = TVModel(title: "TV Title", director: "Emmily", count: 10)
    
    var body: some View {
        VStack{
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
    }
}

struct Typealias_Previews: PreviewProvider {
    static var previews: some View {
        Typealias()
    }
}

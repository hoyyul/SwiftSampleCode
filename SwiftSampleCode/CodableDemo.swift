//
//  CodableDemo.swift
//  SwiftSampleCode
//
//  Created by Lu Haoyu on 2023/06/11.
//

import SwiftUI

struct CustomerModel: Identifiable, Decodable{//decode some datas into CustomerModel
    let id: String // from internet
    let name: String
    let points: Int
    let isPremium: Bool
    
    init(id: String, name: String, points: Int, isPremium: Bool) {
        self.id = id
        self.name = name
        self.points = points
        self.isPremium = isPremium
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case points
        case isPremium
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.points = try container.decode(Int.self, forKey: .points)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
    }
}

class CodableViewModel: ObservableObject{
    
    @Published var customer: CustomerModel? = nil
    
    init(){
        getData()
    }
    
    func getData(){
        guard let data = getJSONData() else {return}
        
        do{
            self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
        }catch let error{
            print("Error decoding. \(error)")
        }
        
        
        
//        if
//            let localData = try? JSONSerialization.jsonObject(with: data, options: []),//json -> dictionary
//            let dictionary = localData as? [String:Any],
//            let id = dictionary["id"] as? String,
//            let name = dictionary["name"] as? String,
//            let points = dictionary["points"] as? Int,
//            let isPremium = dictionary["isPremium"] as? Bool{
//
//            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
//
//            customer = newCustomer
//        }
        
    }
    
    func getJSONData() -> Data?{//data from downloading
        
        let dictionary: [String:Any] = [
            "id" : "12345",
            "name" : "Joe",
            "points" : 5,
            "isPremium" : true
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])//convert dictionary to Json DATA if error return nil to jsonData
        return jsonData
    }
    
    
}


struct CodableDemo: View {
    
    @StateObject var vm = CodableViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            if let customer = vm.customer{// if not nil
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

struct CodableDemo_Previews: PreviewProvider {
    static var previews: some View {
        CodableDemo()
    }
}

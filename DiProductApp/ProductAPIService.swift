//
//  ProductAPIService.swift
//  DiProductApp
//
//  Created by Louis Melchiorre        on 12/7/25.
//

import Foundation
import Combine

protocol ProductAPIServiceProtocol {
    func fetchProducts() -> AnyPublisher<StockResponse, Error>
}

class ProductAPIService: ProductAPIServiceProtocol {
    func fetchProducts() -> AnyPublisher<StockResponse, Error> {
        let ustring = "https://www.finewineandgoodspirits.com/ccstore/v1/stockStatus?actualStockStatus=true&expandStockDetails=true&products=000009000&locationIds=4647"
        
        guard let url = URL(string: ustring) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
        
            .handleEvents(receiveSubscription: { subscription in
        print("Received subscription: \(subscription)")
           }, receiveOutput: { data, response in
               print("Received output: Data - \(data.count) bytes, Response - \(response)")
               // Optionally, print the data as a string if it's text-based
               if let stringData = String(data: data, encoding: .utf8) {
                   print("Received data as string: \(stringData)")
               }
           }, receiveCompletion: { completion in
               switch completion {
               case .finished:
                   print("Receive completion: .finished")
                   
               case .failure(let error):
                   print("Receive completion: .failure - \(error.localizedDescription)")
               }
           }, receiveCancel: {
               print("Receive cancel")
           }, receiveRequest: { demand in
               print("Receive request: \(demand)")
           })
        
            .map { $0.data }
            .decode(type: StockResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


//struct Product: Identifiable, Decodable {
//    let id: String
//    let name: String
//    let price: Double
//    // Add other relevant product properties
//}

struct StockResponse: Decodable {
    var links : [link]
    let autoWrap : Bool
   // var id : UUID = UUID()
    let items : [item]
}



struct link: Decodable {
    let rel: String
    let href: String
}


struct skuStatus: Decodable {
    let productSkuInventoryStatus: Int
}

//     productSkuInventoryDetail
struct productSkuInventoryDetail: Decodable {
    let catalogId: String
    var productId : String
    let preOrderableQuantity: Int?
    let locationId: String
    let orderableQuantity: Int?
    let stockStatus: String
    let availabilityDate: String?
    let backOrderableQuantity: Int?
    let catRefId: String
    let inStockQuantity: Int?
}

struct item: Decodable, Identifiable {
    var id : UUID {
        UUID()
    }
    let stockStatus : String
    //let "100043920" : String
    //let productSkuInventoryStatus: skuStatus
    let locationId : String
    var productSkuInventoryDetails: [productSkuInventoryDetail]
}




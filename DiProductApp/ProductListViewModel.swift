//
//  ProductListViewModel.swift
//  DiProductApp
//
//  Created by Louis Melchiorre        on 12/7/25.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    //var links: [link] = []
    //var id: UUID
    @Published var stockResponse = StockResponse(links:[],autoWrap:false,items:[])
    //var items: [item] = []
    //var autoWrap: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let apiService: ProductAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: ProductAPIServiceProtocol) {
        self.apiService = apiService
        //self.stockResponse = StockResponse(links:[],autoWrap:false,id:UUID(),items:[])
    }

    func loadProducts() {
        isLoading = true
        errorMessage = nil

        apiService.fetchProducts()
  
            .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
//            .sink(
//                
//            receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    self.isLoading = false
//                    break
//                case .failure(let error):
//                    print("Decoding error: \(error)") // This provides detailed info
//                    // ... handle other errors
//                }
//            },
//            receiveValue: { data in
//                // ...
//            }
//        )
        
        
            .sink {
                completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] products in
                print("Received products: \(products)")
                self?.stockResponse = products
            }
            .store(in: &cancellables)
    }
}


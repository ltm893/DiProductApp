//
//  ProductListView.swift
//  DiProductApp
//
//  Created by Louis Melchiorre        on 12/7/25.
//
import SwiftUI


struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel

    init(apiService: ProductAPIServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(apiService: apiService))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Products...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Data Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Here we go")
                  //  Text("Count: \(viewModel.items.count)")
                    List(viewModel.stockResponse.items) { product in
                        
                        Text(product.productSkuInventoryDetails.first!.productId)
                    }
                }
            }
            .navigationTitle("Stock")
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
}




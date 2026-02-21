//
//  FavoriteView.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 21/02/26.
//

import SwiftUI
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
        }
    }
    
    func removeFromFavorites(favoriteProduct: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, FavoriteProductId: favoriteProduct)
            getFavorites()
        }
    }
    
}

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(favoriteProduct: item.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.getFavorites()
        }
    }
}

#Preview {
    FavoriteView()
}

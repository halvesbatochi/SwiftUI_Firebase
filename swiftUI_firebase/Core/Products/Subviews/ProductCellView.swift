//
//  ProductCellView.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 16/02/26.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Price: $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + String(product.category ?? "n/a"))
                Text("Brand: " + String(product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "Test", price: 1, discountPercentage: 2, rating: 1, stock: 2, brand: "test", category: "test", thumbnail: "test", images: nil))
}

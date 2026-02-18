//
//  ProductsManager.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 16/02/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productsDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productsDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    private func getProduct(productId: String) async throws -> Product {
        try await productsDocument(productId: productId).getDocument(as: Product.self)
    }
    
    private func getAllProductsQuery() -> Query {
        productsCollection
    }
    
    private func getAllProductsSortedByPriceQuery(descending: Bool)-> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .limit(to: 3)
    }
    
    private func getAllProductsSortedByCategoryQuery(category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllProductsQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsSortedByCategoryQuery(category: category)
        }
        
        if let lastDocument {
            return try await query
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentWithSnapshot(as: Product.self)
        } else {
            return try await query
                .limit(to: count)
                .getDocumentWithSnapshot(as: Product.self)
        }

    }
    
    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 9999])
            .getDocument(as: Product.self)
    }
    
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        if let lastDocument {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentWithSnapshot(as: Product.self)
        } else {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentWithSnapshot(as: Product.self)
        }
    }
    
}

extension Query {
    
//    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//        let snapshot = try await self.getDocuments()
//        
//        return try snapshot.documents.map({ document in
//            try document.data(as: T.self)
//        })
//    }
    
    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentWithSnapshot(as: type).products
    }
    
    func getDocumentWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
}

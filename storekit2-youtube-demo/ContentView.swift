//
//  ContentView.swift
//  storekit2-youtube-demo
//
//  Created by Paulo Orquillo on 22/10/22.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @StateObject var storeKit = StoreKitManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(storeKit.storeProducts) {product in
                HStack {
                    Text(product.displayName)
                    Spacer()
                    Button(action: {
                        // purchase this product
                        Task { try await storeKit.purchase(product)
                        }
                    }) {
                        CourseItem(storeKit: storeKit, product: product)
                          
                    }
                }
                
            }
        }
        .padding()
        
    }
}

struct CourseItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .padding(10)
            } else {
                Text(product.displayPrice)
                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedCourses) { course in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

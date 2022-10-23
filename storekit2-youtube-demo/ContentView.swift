//
//  ContentView.swift
//  storekit2-youtube-demo
//
//  Created by Paulo Orquillo on 22/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var storeKit = StoreKitManager()
    @State var isPurchased: Bool = false
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
                        if isPurchased {
                            Text(Image(systemName: "checkmark"))
                                .bold()
                        } else {
                            Text(product.displayPrice)
                                .padding(10)
                        }
                          
                    }
                    // on appear of each row
                }.onAppear {
                    Task {
                        isPurchased = (try? await storeKit.isPurchased(product)) ?? false
                    }
                }
            }
        }
        .padding()
        
    }
    
    func buyCourse() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

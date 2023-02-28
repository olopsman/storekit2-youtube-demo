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
        List {
           Section("Courses") {
                ForEach(storeKit.courses) { product in
                    CourseItem(storeKit: storeKit, product: product)
                }
            }
            Section("Subscriptions") {
                ForEach(storeKit.subscriptions) { product in
                    CourseItem(storeKit: storeKit, product: product)
                }
           }
            
            Button("Restore Purchases", action: {
                Task {
                    // this calls systemp prompt to authenticate
                    try? await AppStore.sync()
                }
            })
        }       
    }
}

struct CourseItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            HStack {
                Text(product.displayName)
                Spacer()
                Button(action: {
                    print(product)
                    Task {
                        try? await storeKit.purchase(product)
                    }
                }) {
                    if isPurchased {
                        Text(Image(systemName: "checkmark"))
                            .bold()
                            .padding(10)
                    } else {
                        Text(product.displayPrice)
                            .padding(10)
                    }
                }
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

//
//  ContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 10.12.24.
//

import SwiftUI

struct ContentView: View {

    let itemName = "tshirt"
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    var outfit: (shirt: ClothingItem, pants: ClothingItem)?
    var fetchFailed: Bool = false

    var body: some View {
        // No NavigationStack here on purpose: this view is pushed from
        // HomeView's stack, and nesting a second stack inside a pushed
        // view breaks the pop transition.
        ZStack {
            mainColor.ignoresSafeArea()
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("XXXXXXXX")
                        .padding()
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                }
                .offset(y: -330)
                VStack{
                    if let outfit = outfit {
                        OutfitCollageView(shirt: outfit.shirt, pants: outfit.pants)
                            .padding()
                    } else if fetchFailed {
                        Text("No outfit found. Add more items to your wardrobe and try again.")
                            .font(.custom("Helvetica", size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                }
            }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

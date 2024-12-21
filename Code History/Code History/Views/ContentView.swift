//
//  ContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 10.12.24.
//

import SwiftUI

struct ContentView: View {
    let shirt: ClothingItem?
    let pants: ClothingItem?
    
    let itemName = ["tshirt", "tshirt", "tshirt"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)

    var body: some View {
        NavigationStack {
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
                    Spacer()
                }
                VStack {
                    if let shirt = shirt {
                        Text("\(shirt.color) \(shirt.code) shirt")
                            .padding()
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                    }
                    
                    if let pants = pants {
                        Text("\(pants.color) \(pants.code) pants")
                            .padding()
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Image(systemName: "tshirt")
                        .padding()
                        .font(.custom("Helvetica", size: 80))
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(shirt: nil, pants: nil)
    }
}

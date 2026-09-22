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
                }
                .offset(y: -330)
                VStack{
                    if let outfit = outfit{
                        NavigationLink(destination: ItemView(itemName: itemName, imageName: itemName, description: "You should be looking at a \(outfit.shirt.color) \(outfit.shirt.type). This is a \(outfit.pants.dresscode) shirt, so mind the occassion you are wearing it to. The \(outfit.pants.fit) fit enhances your silhouette. Have fun!")) {
                            VStack {
                                Image(systemName: itemName)
                                    .font(.custom("Helvetica", size: 100))
                                    .foregroundColor(.white)
                                    .padding()
                                /*Text("This is a \(outfit.shirt.fit) \(outfit.shirt.color) \(outfit.shirt.type) (\(outfit.shirt.dresscode)).")
                                    .font(.custom("Helvetica", size: 14))
                                    .foregroundColor(.white)
                                 */
                            }
                        }
                        .padding()
                    } else {
                        Text("Loading...")
                    }

                    if let outfit = outfit {
                        NavigationLink(destination: ItemView(itemName: "PANTS", imageName: "skew", description: "You should be looking at a pair of \(outfit.pants.color) \(outfit.pants.type). They are a \(outfit.pants.dresscode) pair of pants, so mind the occassion you are wearing them to. The \(outfit.pants.fit) fit defines your silhouette. Have fun!")) {
                            VStack {
                                Image(systemName: "skew")
                                    .font(.custom("Helvetica", size: 100))
                                    .foregroundColor(.white)
                                    .padding()
                                    /*Text("This is a \(outfit.pants.fit) \(outfit.pants.color) \(outfit.pants.type) (\(outfit.pants.dresscode)).")
                                        .font(.custom("Helvetica", size: 14))
                                        .foregroundColor(.white)
                                     */
                                }
                            }
                        }
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

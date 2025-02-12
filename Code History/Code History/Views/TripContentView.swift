//
//  TripContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 14.12.24.
//

import SwiftUI

struct TripContentView: View {
    let mainColor = Color.black
    private let hSpacing: CGFloat = 10
    
    private let firstRowImages: [String] = ["tshirt.circle.fill", "photo.circle", "globe", "skew"]
    private let secondRowImages: [String] = ["tshirt","photo", "globe", "hanger"]
    private let thirdRowImages: [String] = ["shoe.circle", "tshirt.fill", "shoe.circle.fill",  "shoeprints.fill"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: hSpacing) {
                        ForEach(firstRowImages, id: \.self) { imageName in
                            NavigationLink(destination: TripItemView(itemName: imageName, imageName: imageName)) {
                                Image(systemName: imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                }
                .frame(maxHeight: 120)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: hSpacing) {
                        ForEach(secondRowImages, id: \.self) { imageName in
                            NavigationLink(destination: TripItemView(itemName: imageName, imageName: imageName)) {
                                Image(systemName: imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                }
                .frame(maxHeight: 120)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: hSpacing) {
                        ForEach(thirdRowImages, id: \.self) { imageName in
                            NavigationLink(destination: TripItemView(itemName: imageName, imageName: imageName)) {
                                Image(systemName: imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                }
                .frame(maxHeight: 120)
            }
            .padding()
        }
    }
}

#Preview {
    TripContentView()
}

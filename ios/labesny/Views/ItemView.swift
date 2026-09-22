//
//  ItemView.swift
//  Code History
//
//  Created by Omar Aboulazm on 13.12.24.
//

import SwiftUI

struct ItemView: View {
  let itemName: String
  let imageName: String
  let description: String
  var imageURL: String? = nil
  @State private var isAnimating = false


  var body: some View {
    VStack {
        Spacer()
      Text("\"\(itemName)\"".uppercased())
        .font(.custom("Helvetica", size: 30))
        .symbolEffect(.bounce, options: .repeating, value: isAnimating)
        .onAppear { isAnimating = true }  // Start animation when view appears
        .padding()
      if let imageURLString = imageURL, let url = URL(string: imageURLString) {
          AsyncImage(url: url) { image in
              image.resizable().scaledToFit()
          } placeholder: {
              Image(systemName: imageName)
                  .font(.custom("Helvetica", size: 200))
          }
          .frame(width: 200, height: 200)
          .padding()
      } else {
          Image(systemName: imageName)
            .font(.custom("Helvetica", size: 200))
            .padding()
      }
        Spacer()
      Text(description)
        .font(.custom("Helvetica", size: 15))
        .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
        .frame(width: 300)
      Spacer()
      Button {
      } label: {
        Text("owned")
          .font(.custom("Helvetica", size: 20))
      }
      Spacer()
    }
  }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(itemName: "tshirt", imageName: "tshirt", description: "This is a desription of the item Or any facts you want to write about it. Ay 7aga 3ayez tektebha mel akher...")
    }
}

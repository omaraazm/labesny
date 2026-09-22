//
//  TripItemView.swift
//  Code History
//
//  Created by Omar Aboulazm on 14.12.24.
//

import SwiftUI

import SwiftUI

struct TripItemView: View {
  let itemName: String
  let imageName: String
  
  var body: some View {
    VStack {
        Spacer()
      Text("\"\(itemName)\"".uppercased())
        .font(.custom("Helvetica", size: 30))
        .padding()
      Image(systemName: imageName)
        .font(.custom("Helvetica", size: 200))
        .padding()
        Spacer()
      Text("This is a desription of the item Or any facts you want to write about it. Ay 7aga 3ayez tektebha mel akher...")
        .font(.custom("Helvetica", size: 15))
        .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
        .frame(width: 300)
      Spacer()
      Button {
        print("Button tapped")
      } label: {
        Text("add to suitcase")
          .font(.custom("Helvetica", size: 20))
      }
      Spacer()
    }
  }
}

struct TripItemView_Previews: PreviewProvider {
    static var previews: some View {
        TripItemView(itemName: "tshirt", imageName: "tshirt")
    }
}

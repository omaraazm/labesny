//
//  ContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 10.12.24.
//

import SwiftUI

struct WardrobeView: View {
    @StateObject private var wardrobeService = WardrobeService()
    @State private var items: [ClothingItem] = []
    @StateObject private var weatherService = WeatherService.shared
    @State private var temperature: Double = -20
    @State private var isSidebarOpen = false
    @State private var showAddItemDrawer = false
    
    let itemName = ["tshirt", "tshirt", "tshirt"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                
                // Sidebar
                HStack {
                    if isSidebarOpen {
                        VStack(alignment: .leading, spacing: 30) {
                            NavigationLink(destination: TripView()) {
                                HStack {
                                    Image(systemName: "airplane.departure")
                                        .foregroundColor(.white)
                                    Text("My Trips")
                                        .foregroundColor(.white)
                                }
                            }
                            
                            NavigationLink(destination: WardrobeView()) {
                                HStack {
                                    Image(systemName: "bag.fill")
                                        .foregroundColor(.white)
                                    Text("My Wardrobe")
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 100)
                        .padding(.horizontal)
                        .frame(width: 200)
                        .background(Color.black.opacity(0.5))
                        .transition(.move(edge: .leading))
                    }
                    
                    Spacer()
                }
                .zIndex(1)
                
                // Sidebar toggle button
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSidebarOpen.toggle()
                            }
                        }) {
                            Image(systemName: isSidebarOpen ? "chevron.left" : "chevron.right")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(8)
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    Spacer()
                }
                .zIndex(2)
                
                VStack {
                    // Top navigation bar with plane and bag buttons
                    /*
                    HStack {
                        NavigationLink(destination: TripView()) {
                            Image(systemName: "airplane.departure")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        NavigationLink(destination: WardrobeView()) {
                            Image(systemName: "bag.fill.badge.plus")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                    .padding(.horizontal)
                    */
                    Spacer()
                                        
                    // Scrollable list of items
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(items, id: \.self) { item in
                                Text("\(item.fit) \(item.color) \(item.type) (\(item.dresscode))")
                                    .font(.custom("Helvetica", size: 14))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        
                    }
                    .offset(y: 20)
                    .frame(maxHeight: 600)
                    
                    // Generate button
                    Button(action: {
                        showAddItemDrawer = true
                    }) {
                        Image(systemName: "plus")
                            .font(.custom("Helvetica", size: 20).weight(.bold))
                            .foregroundColor(.white)
                            .padding()
                            .border(Color.white, width: 2)
                            .cornerRadius(10)
                    }
                    .padding(20) //20
                    //.frame(height: 10)
                    //.offset(y: 90)
                }
                
                // Logo and title positioned at the top
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("XXXXXXXX")
                        .padding(.top, 4)
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 60)
                .offset(y: -20)
            }
            .blur(radius: showAddItemDrawer ? 3 : 0)
            .sheet(isPresented: $showAddItemDrawer) {
                AddItemDrawer(wardrobeService: wardrobeService, imageService: ImageService())
                    .presentationDetents([.medium])
            }
        }
        .task {
            do {
                try await wardrobeService.fetchItems()
                items = wardrobeService.items
            } catch {
                print("Error fetching items: \(error)")
            }
        }
    }
}

struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}

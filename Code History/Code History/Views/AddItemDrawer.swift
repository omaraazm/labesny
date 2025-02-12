//
//  AddItemDrawer.swift
//  labesny
//
//  Created by Omar Aboulazm on 05.02.25.
//

import SwiftUI
import Foundation
import UIKit

struct AddItemDrawer: View {
    @State private var selectedType: ClothingType = .shirt
    @State private var selectedColor: String = ""
    @State private var selectedDresscode: DressCode = .casual
    @State private var selectedFit: ClothingFit = .regular
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var wardrobeService: WardrobeService
    //@StateObject private var imageService = ImageService()
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var imageService: ImageService
    @State private var uploadedImageURL: String? = nil
    @State private var uploadError: String? = nil

    
    var body: some View {
        VStack{
            VStack(spacing: 20) {
                VStack(spacing: 20){
                    // Clothing Type Dropdown
                    Picker("Type", selection: $selectedType) {
                        ForEach(ClothingType.allCases, id: \.self) { type in
                            Text(type.rawValue.uppercased()).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .font(Font.custom("Helvetica", size: 14))
                    .padding(.horizontal)
                    //.background(Color.gray.opacity(0.2))
                    
                    // Dresscode Dropdown
                    Picker("Dresscode", selection: $selectedDresscode) {
                        ForEach(DressCode.allCases, id: \.self) { dresscode in
                            Text(dresscode.rawValue.uppercased()).tag(dresscode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .font(Font.custom("Helvetica", size: 14))
                    .padding(.horizontal)
                    //.background(Color.gray.opacity(0.2))
                    
                    
                    
                    // Fit Dropdown
                    Picker("Fit", selection: $selectedFit) {
                        ForEach(ClothingFit.allCases, id: \.self) { fit in
                            Text(fit.rawValue.uppercased()).tag(fit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .font(Font.custom("Helvetica", size: 14))
                    .padding(.horizontal)
                    //.background(Color.gray.opacity(0.2))
                    
                    // Color Input Field
                    TextField("ENTER COLOR", text: $selectedColor)
                        .font(Font.custom("Helvetica", size: 13))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .offset(y:30)
                .background(Color.white)
                
                VStack {
                    if let error = uploadError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    // Upload Image Button
                    Button(action: {
                        // Show the image picker immediately
                        isPickerShowing = true
                    }) {
                        HStack {
                            Text("U P L O A D")
                            Image(systemName: "photo.fill")
                        }
                        .font(.custom("Helvetica", size: 17).weight(.regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(7)
                    }
                    .padding()
                    .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    }
                    .onChange(of: selectedImage) { newImage in
                        guard let image = newImage else { return }
                        Task {
                            do {
                                // Reset error state
                                uploadError = nil
                                
                                // Upload the image and store the URL
                                let imageURL = try await imageService.uploadImage(image)
                                uploadedImageURL = imageURL
                                print("Image uploaded successfully: \(imageURL)")
                            } catch {
                                uploadError = "Failed to upload image. Please try again."
                                print("Error uploading image: \(error)")
                            }
                        }
                    }
                }
                .offset(y:10)
            }
            .offset(y: 60)
            .background(Color.white)
            VStack{
                // Confirm Button
                Button(action: {
                    Task {
                        do {
                            // Create and add the item with the stored image URL
                            let newItem = ClothingItem(
                                type: selectedType.rawValue,
                                color: selectedColor,
                                dresscode: selectedDresscode.rawValue,
                                fit: selectedFit.rawValue
                                //imageURL: uploadedImageURL
                            )
                            
                            try await wardrobeService.addItem(newItem)
                            dismiss()
                        } catch {
                            print("Error adding item: \(error)")
                        }
                    }
                }) {
                    Text("C O N F I R M")
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Color.white)
            //.padding(.top, 0)
            .offset(y: 50)
        }
        .offset(y: -40)
    }
}


#Preview {
    AddItemDrawer(wardrobeService: WardrobeService(), imageService: ImageService())
}

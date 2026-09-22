//
//  ImageService.swift
//  labesny
//
//  Created by Omar Aboulazm on 09.02.25.
//

import Foundation
import UIKit
import Foundation
import UIKit

// the goal of this file is to connect the selected image in ImagePicker and connect it wit the api. The image should be posted on the api through the post request"upload image"
// the api functionalities are to be found in empty.md
// UI where one selects the image is in AddItemDrawer.swiftui
//Disregard anything written in the file "ImageService" and procceed as if it doesnt exist

class ImageService {
    func uploadImage(_ image: UIImage) async throws -> String {
        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageServiceError.invalidImageData
        }

        // Create the URL for the upload endpoint
        let url = URL(string: "\(Secrets.backendBaseURL)/upload-image/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Create a unique boundary string
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Build the multipart/form-data body
        var body = Data()
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"uploaded_image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send the request
        let (data, response) = try await URLSession.shared.upload(for: request, from: body)
        
        // Check for successful response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ImageServiceError.uploadFailed
        }
        
        // Parse the response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let imageURL = json["image_url"] as? String else {
            throw ImageServiceError.invalidResponse
        }

        return imageURL
    }
}

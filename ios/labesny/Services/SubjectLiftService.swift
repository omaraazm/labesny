//
//  SubjectLiftService.swift
//  labesny
//
//  Cuts the main subject out of a photo on-device (Vision), used to
//  composite wardrobe item photos into the outfit collage without any
//  backend/third-party image processing.
//

import Vision
import UIKit

enum SubjectLiftError: Error {
    case noCGImage
}

actor SubjectLiftService {
    static let shared = SubjectLiftService()

    private var cache: [String: UIImage] = [:]

    /// Returns a cutout of the main subject with a transparent background,
    /// or nil if Vision couldn't find a clear subject in the image
    /// (caller should fall back to the original image in that case).
    func liftSubject(from image: UIImage, cacheKey: String) async throws -> UIImage? {
        if let cached = cache[cacheKey] {
            return cached
        }

        guard let cgImage = image.cgImage else {
            throw SubjectLiftError.noCGImage
        }

        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        guard let observation = request.results?.first,
              !observation.allInstances.isEmpty else {
            return nil
        }

        let maskedPixelBuffer = try observation.generateMaskedImage(
            ofInstances: observation.allInstances,
            from: handler,
            croppedToInstancesExtent: true
        )

        let ciImage = CIImage(cvPixelBuffer: maskedPixelBuffer)
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }

        let result = UIImage(cgImage: outputCGImage)
        cache[cacheKey] = result
        return result
    }
}

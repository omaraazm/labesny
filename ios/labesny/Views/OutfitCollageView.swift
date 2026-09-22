//
//  OutfitCollageView.swift
//  labesny
//
//  Composites the shirt + pants photos into one layered "flat-lay" image
//  using on-device background removal (SubjectLiftService), with a plain
//  side-by-side SF Symbol fallback when a photo is missing or Vision
//  can't find a clear subject.
//

import SwiftUI

struct OutfitCollageView: View {
    let shirt: ClothingItem
    let pants: ClothingItem

    @State private var shirtCutout: UIImage?
    @State private var pantsCutout: UIImage?
    @State private var isLoading = true
    @State private var useFallback = false

    var body: some View {
        VStack(spacing: 16) {
            if useFallback {
                fallbackLayout
            } else if isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(height: 260)
            } else {
                collage
            }

            Text(caption)
                .font(.custom("Helvetica", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .task {
            await loadCutouts()
        }
    }

    private var caption: String {
        "\(shirt.color) \(shirt.type) \u{00B7} \(pants.color) \(pants.type)"
    }

    private var collage: some View {
        ZStack {
            if let pantsCutout {
                Image(uiImage: pantsCutout)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .rotationEffect(.degrees(4))
                    .offset(y: 90)
            }
            if let shirtCutout {
                Image(uiImage: shirtCutout)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190)
                    .rotationEffect(.degrees(-6))
                    .offset(y: -40)
            }
        }
        .frame(height: 320)
    }

    private var fallbackLayout: some View {
        HStack(spacing: 24) {
            Image(systemName: "tshirt")
                .font(.custom("Helvetica", size: 80))
                .foregroundColor(.white)
            Image(systemName: "skew")
                .font(.custom("Helvetica", size: 80))
                .foregroundColor(.white)
        }
        .frame(height: 260)
    }

    private func loadCutouts() async {
        guard
            let shirtURLString = shirt.imageURL, let shirtURL = URL(string: shirtURLString),
            let pantsURLString = pants.imageURL, let pantsURL = URL(string: pantsURLString)
        else {
            useFallback = true
            isLoading = false
            return
        }

        do {
            async let shirtImage = downloadImage(from: shirtURL)
            async let pantsImage = downloadImage(from: pantsURL)
            let (shirtUIImage, pantsUIImage) = try await (shirtImage, pantsImage)

            async let shirtLift = SubjectLiftService.shared.liftSubject(from: shirtUIImage, cacheKey: shirtURLString)
            async let pantsLift = SubjectLiftService.shared.liftSubject(from: pantsUIImage, cacheKey: pantsURLString)
            let (shirtResult, pantsResult) = try await (shirtLift, pantsLift)

            if let shirtResult, let pantsResult {
                shirtCutout = shirtResult
                pantsCutout = pantsResult
            } else {
                useFallback = true
            }
        } catch {
            print("Error building outfit collage: \(error)")
            useFallback = true
        }

        isLoading = false
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw SubjectLiftError.noCGImage
        }
        return image
    }
}

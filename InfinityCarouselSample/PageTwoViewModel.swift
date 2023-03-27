//
//  PageTwoViewModel.swift
//  InfinityCarouselSample
//
//  Created by Yuri Gerasimchuk on 27.03.2023.
//

import SwiftUI

// As we call fetchData onAppear, mark to run it on main thread
@MainActor
class PageTwoViewModel: ObservableObject {
    @Published var descriptionModels = Description()
    var imageURLS = [String]()
    var imageIndices = [Int]()
    
    // To track large images we create fake arrays for urls and indices
    var fakeImageURLs = [String]()
    var fakeImageIndices = [Int]()
    
    func fetchData() async {
        let url = URL(string: "https://run.mocky.io/v3/f7f99d04-4971-45d5-92e0-70333383c239")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            descriptionModels = try JSONDecoder().decode(Description.self, from: data)
        } catch {
            print("Error loading data")
        }
        
        // To populate imageURLs array
        imageURLS = descriptionModels.imageURLs
        // To populate imageIndices array
        imageIndices = Array(0..<imageURLS.count)
        
        guard let first = imageURLS.first else { return }
        guard let last = imageURLS.last else { return }
        
        fakeImageURLs = imageURLS
        // We add first image from original images at the end
        fakeImageURLs.append(first)
        // and last image from original images in front so that to make a-la infinite loop
        fakeImageURLs.insert(last, at: 0)
        
        fakeImageIndices = Array(0..<fakeImageURLs.count)
    }
}

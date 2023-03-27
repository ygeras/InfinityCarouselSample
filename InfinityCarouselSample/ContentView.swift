//
//  ContentView.swift
//  InfinityCarouselSample
//
//  Created by Yuri Gerasimchuk on 27.03.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var modelDesc = PageTwoViewModel()
    @State private var fakeIndex = 1
    @State private var selectedImage = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text(modelDesc.descriptionModels.name)
                    .font(.title)
                
                Text(modelDesc.descriptionModels.description)
                    .fontDesign(.rounded)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                // Small Pictures
                HStack {
                    ForEach(modelDesc.imageIndices, id: \.self) { index in
                        AsyncImage(url: URL(string: "\(modelDesc.imageURLS[index])")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        // To show which thumbnail image is currently chosen
                                        selectedImage = modelDesc.imageIndices[index]
                                        // To track which large image is chosen
                                        fakeIndex = modelDesc.imageIndices[index] + 1
                                    }
                                    .mask {
                                        RoundedRectangle(cornerRadius: 3)
                                    }
                                    .shadow(radius: selectedImage == index ? 3 : 0)
                            } else if phase.error != nil {
                                Text("There was an error loading the image.")
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .frame(width: 50, height: 50)
                }
                .padding(.horizontal)
                
                // Infinity Carousel with large pictures
                TabView(selection: $fakeIndex) {
                    ForEach(modelDesc.fakeImageIndices, id: \.self) { index in
                        AsyncImage(url: URL(string: "\(modelDesc.fakeImageURLs[index])")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .tag(fakeIndex)
                            } else if phase.error != nil {
                                Text("There was an error loading the image.")
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .padding()
                    
                }
                .frame(height: 300)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: fakeIndex) { newValue in
                    // when we reach fake index 0 we jump to last image in the original images array which is -2 in fake array
                    if fakeIndex == 0 {
                        fakeIndex = modelDesc.fakeImageIndices.count - 2
                    }
                    // when we reach last fake index we jump to first image in original images array which is at index 0 in fake array
                    if fakeIndex == modelDesc.fakeImageIndices.count - 1 {
                        fakeIndex = 1
                    }
                    // To update selected image which will show what image is chosen
                    selectedImage = fakeIndex - 1
                }
            }
        }
        .onAppear {
            Task {
                await modelDesc.fetchData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

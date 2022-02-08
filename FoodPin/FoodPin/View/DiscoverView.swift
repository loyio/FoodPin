//
//  DiscoverView.swift
//  FoodPin
//
//  Created by Loyio Hex on 2/7/22.
//

import SwiftUI
import CloudKit

struct DiscoverView: View {
    @StateObject private var cloudStore: RestaurantCloudStore = RestaurantCloudStore()
    
    @State private var showLoadingIndicator = false
    
    var body: some View {
        NavigationView {
            List(cloudStore.restaurants, id: \.recordID) { restaurant in
                HStack {
                    AsyncImage(url: getImageURL(restaurant: restaurant)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.purple.opacity(0.1)
                    }
                    .frame(height: 200)
                    .cornerRadius(30)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(restaurant.object(forKey: "name") as! String)
                            .font(.title2)
                        
                        Text(restaurant.object(forKey: "location") as! String)
                            .font(.headline)
                        
                        Text(restaurant.object(forKey: "type") as! String)
                            .font(.subheadline)
                        
                        Text(restaurant.object(forKey: "description") as! String)
                            .font(.subheadline)
                    }
                    .padding(10)
                }
                .listRowSeparator(.hidden)
            }
            .refreshable {
                cloudStore.fetchRestaurantsWithOperational() {
                    showLoadingIndicator = false
                }
            }
            .listStyle(PlainListStyle())
            .task {
                cloudStore.fetchRestaurantsWithOperational {
                    showLoadingIndicator = false
                }
            }
            .onAppear() {
                showLoadingIndicator = true
            }
            
            if showLoadingIndicator {
                ProgressView()
            }
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.automatic)
    }
    
    private func getImageURL(restaurant: CKRecord) -> URL? {
        guard let image = restaurant.object(forKey: "image"),
              let imageAsset = image as? CKAsset else {
                  return nil
        }
        
        return imageAsset.fileURL
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}

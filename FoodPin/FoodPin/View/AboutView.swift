//
//  AboutView.swift
//  FoodPin
//
//  Created by Loyio Hex on 2/6/22.
//

import SwiftUI

struct AboutView: View {
    enum WebLink: String, Identifiable {
        case rateUs = "https://www.apple.com/ios/app-store"
        case feedback = "https://github.com/loyio/blog/issues/79"
        case twitter = "https://www.twitter.com/loyiome"
        case facebook = "https://www.facebook.com/loyiome"
        case instagram = "https://www.instagram.com/loyiohex"
        
        var id: UUID {
            UUID()
        }
    }
    
    @State private var link: WebLink?
    
    var body: some View {
        NavigationView {
            List {
                Image("about")
                    .resizable()
                    .scaledToFit()
                
                Section {
                    Link(destination: URL(string: WebLink.rateUs.rawValue)!, label: {
                            Label("Rate us on App Store", image: "store")
                                .foregroundColor(.primary)
                    })
                    
                    Label("Tell up your feedback", image: "chat")
                        .onTapGesture {
                            link = .feedback
                        }
                }
                
                Section {
                    Label("Twitter", image: "twitter")
                        .onTapGesture {
                            link = .twitter
                        }
                    Label("Facebook", image: "facebook")
                        .onTapGesture {
                            link = .facebook
                        }
                    Label("Instagram", image: "instagram")
                        .onTapGesture {
                            link = .instagram
                        }
                }
            }
            .listStyle(GroupedListStyle())
            
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.automatic)
            .sheet(item: $link) { item in
                if let url = URL(string: item.rawValue) {
                    SafariView(url: url)
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

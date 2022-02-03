//
//  ContentView.swift
//  FoodPin
//
//  Created by Loyio Hex on 1/22/22.
//

import SwiftUI

struct RestaurantListView: View {
    
    @FetchRequest(
        entity: Restaurant.entity(),
        sortDescriptors: [])
    var restaurants: FetchedResults<Restaurant>
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showNewRestaurant = false
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                if restaurants.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id:\.self) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index])) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            BasicTextImageRow(restaurant: restaurants[index])
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar{
                Button(action: {
                    self.showNewRestaurant = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .accentColor(.primary)
        .sheet(isPresented: $showNewRestaurant){
            NewRestaurantView()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search restaurants...")
        .onChange(of: searchText) { searchText in
            let predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
            
            restaurants.nsPredicate = predicate
        }
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = restaurants[index]
            context.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

struct BasicTextImageRow: View {
    
    // MARK: - Binding
    
    @ObservedObject var restaurant: Restaurant
    
    // MARK: - State variables
    
    @State private var showOptions = false
    @State private var showError = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let imageData = restaurant.image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .frame(width: 120, height: 118)
                    .cornerRadius(20)
            }
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            if restaurant.isFavorite {
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }){
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }){
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            
            Button(action: {
                self.showOptions.toggle()
            }){
                HStack{
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet avaiable"),
                  message: Text("Sorry, this feature is not available yet, Please retry later."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .cancel())
        }
        .sheet(isPresented: $showOptions){
            let defaultText = "Just checking in at \(restaurant.name)"
            
            if let imageData = restaurant.image, let imageToShare = UIImage(data: imageData){
                ActivityView(activityItems: [defaultText, imageToShare])
            }else {
                ActivityView(activityItems: [defaultText])
            }
        }
    }
}

struct FullImageRow: View {
    
    var imageName: String
    var name: String
    var type: String
    var location: String
    @Binding var isFavorite: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                    
                    Text(type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                if isFavorite {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}


struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        BasicTextImageRow(restaurant: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
        
        FullImageRow(imageName: "cafedeadend", name: "Cafe Deadend", type: "Cafe", location: "Hong Kong", isFavorite: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}

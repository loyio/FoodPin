//
//  NewRestaurantView.swift
//  FoodPin
//
//  Created by Loyio Hex on 1/30/22.
//

import SwiftUI

struct NewRestaurantView: View {
    
    @ObservedObject private var restaurantFormViewModel: RestaurantFormViewModel
    
    @Environment(\.managedObjectContext) var context
    
    init() {
        let viewModel = RestaurantFormViewModel()
        viewModel.image = UIImage(named: "newphoto")!
        restaurantFormViewModel = viewModel
    }
    
    @State private var showPhotoOptions = false
    
    @Environment(\.dismiss) var dismiss
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    @State private var photoSource: PhotoSource?
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack {
                    Image(uiImage: restaurantFormViewModel.image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom)
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                    FormTextField(label: "NAME", placeholder: String(localized: "Fill in the restaurant name"), value: $restaurantFormViewModel.name)
                    FormTextField(label: "TYPE", placeholder: String(localized: "Fill in the restaurant type"), value: $restaurantFormViewModel.type)
                    FormTextField(label: "ADDRESS", placeholder: String(localized: "Fill in the restaurant address"), value: $restaurantFormViewModel.location)
                    FormTextField(label: "PHONE", placeholder: String(localized: "Fill in the restaurant phone"), value: $restaurantFormViewModel.phone)
                    FormTextView(label: "DESCRIPTION", value: $restaurantFormViewModel.description, height: 100)
                }
                .padding()
            }
            
            .navigationTitle("New Restaurant")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                        dismiss()
                    }){
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(Color("NavigationBarTitle"))
                    }
                }
            }
        }
        .actionSheet(isPresented: $showPhotoOptions) {
            ActionSheet(title: Text(String(localized: "Choose your photo source")),
            message: nil,
            buttons: [
                .default(Text(String(localized: "Camera"))){
                    self.photoSource = .camera
                },
                .default(Text(String(localized: "Photo Library"))){
                    self.photoSource = .photoLibrary
                },
                .cancel()
            ])
        }
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $restaurantFormViewModel.image).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $restaurantFormViewModel.image).ignoresSafeArea()
            }
        }
    }
    
    
    private func save() {
        let restaurant = Restaurant(context: context)
        let cloudStore = RestaurantCloudStore()
        cloudStore.saveRecordToCloud(restaurant: restaurant)
        
        restaurant.name = restaurantFormViewModel.name
        restaurant.type = restaurantFormViewModel.type
        restaurant.location = restaurantFormViewModel.location
        restaurant.phone = restaurantFormViewModel.phone
        restaurant.image = restaurantFormViewModel.image.pngData()!
        restaurant.summary = restaurantFormViewModel.description
        restaurant.isFavorite = false
        
        do {
            try context.save()
        } catch {
            print(String(localized: "Failed to save the record..."))
            print(error.localizedDescription)
        }
    }
}

struct FormTextField: View {
    let label: String
    var placeholder: String = ""
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextField(placeholder, text: $value)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.vertical, 10)
            
            
        }
    }
    
}

struct FormTextView: View {
    
    let label: String
    
    @Binding var value: String
    
    var height: CGFloat = 200.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextEditor(text: $value)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.top, 10)
        }
    }
}

struct NewRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NewRestaurantView()
        
        FormTextField(label: "NAME", placeholder: String(localized: "Fill in the restaurant name"), value: .constant(""))
            .previewLayout(.fixed(width: 300, height: 200))
        
        FormTextView(label: "Description", value: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}

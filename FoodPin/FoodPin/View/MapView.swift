//
//  MapView.swift
//  FoodPin
//
//  Created by Loyio Hex on 1/26/22.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    private func convertAddress(location: String) {
        //Get location
        let geoCoder = CLGeocoder();
        
        geoCoder.geocodeAddressString(location, completionHandler: {placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,let location = placemarks[0].location else{
                      return
            }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            
            self.annotatedItem = AnnotatedItem(coordinate: location.coordinate)
        })
    }
    
    
    var location: String = ""
    @State private var annotatedItem: AnnotatedItem = AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773))
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [], annotationItems: [annotatedItem]){item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .task {
            convertAddress(location: location)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: "54 Frith Street London W1D 4SL United Kingdom")
    }
}

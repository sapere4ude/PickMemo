//
//  Marker.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation
import NMapsMap

class MarkerDTO {
    let uuid: UUID
    var lat: Double
    var lng: Double
    var place: String
    
    var nmfMarker : NMFMarker
    
    init(marker: Marker){
        self.uuid = marker.uuid
        self.lat = marker.lat ?? 0
        self.lng = marker.lng ?? 0
        self.place = marker.place ?? ""
        
        nmfMarker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
    }
}

class Marker: Codable {
    
    var uuid: UUID = UUID()
    
    var lat: Double?
    var lng: Double?
    var place: String?
    
    init(lat: Double?,
         lng: Double?,
         place: String?) {
        self.lat = lat
        self.lng = lng
        self.place = place
    }
    
    
    func getNMFMarker() -> NMFMarker {
        return NMFMarker(position: NMGLatLng(lat: self.lat ?? 0, lng: self.lng ?? 0))
    }
}

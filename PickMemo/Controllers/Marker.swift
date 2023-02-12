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
    
//    /// 마커 가져오기
//    /// - Returns:
//    fileprivate func getMarker() -> NMFMarker {
//
//        if let nmfMarker = self.tempNmfMarker {
//            return nmfMarker
//        }
//
//        let marker = NMFMarker()
//
//        marker.position = NMGLatLng(lat: lat, lng: lng)
////        int numericFormUUID = (int)UUIDString.hash
////        marker.tag = UInt(self.uuid.hashValue)
//
//        self.tempNmfMarker = marker
//
//        return marker
//    }
}

class Marker: Codable {
    
    let uuid: UUID = UUID()
    
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

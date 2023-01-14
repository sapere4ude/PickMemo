//
//  Marker.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation
import NMapsMap

class Marker: Codable {
    
//    let lat: Double?
//    let lng: Double?
//    let place: String?
    var userInfo: [String: String] = ["": ""]
    
//    init(lat: Double?,
//         lng: Double?,
//         place: String?) {
//        self.lat = lat
//        self.lng = lng
//        self.place = place
//    }
    
    init(userInfo: [String : String]) {
        self.userInfo = userInfo
    }
    
}

//
//  CLLocationProxy.swift
//  PickMemo
//
//  Created by Jae jun Yoo🧑🏻‍💻 on 2023/02/12.
//

import Foundation
import Combine
import CoreLocation

class CLLocationProxy: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // 최신 lat, lng
    var recentLocationAction = PassthroughSubject<(Double, Double), Never>()
    
    var checkLocationAuthStatusAction = PassthroughSubject<(), Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    override init() {
        super.init()
        self.checkLocationAuthStatusAction.send(())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#fileID, #function, #line, "- locations: \(locations)")
        if let firstLocation = locations.first {
            let lat = firstLocation.coordinate.latitude
            let lng = firstLocation.coordinate.longitude
            self.recentLocationAction.send((lat, lng))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#fileID, #function, #line, "- ")
        self.checkLocationAuthStatusAction.send(())
    }
}

//
//  Marker.swift
//  PickMemo
//
//  Created by kant on 2022/12/31.
//

import Foundation

class Marker: Codable {
    var latlng: String?
    var place: String?
    
    init(latlng: String?,
         place: String?) {
        self.latlng = latlng
        self.place = place
    }
    
//    enum CodingKeys: String, CodingKey {
//        case latlng = "latlng"
//        case symbol = "symbol"
//    }
}

//import Foundation
//
//class Memo: Codable, Hashable {
//
//    var uuid = UUID()
//    var title: String?
//    var memo: String?
//    var category: String?
//
//    init(title: String?,
//         memo: String?,
//         category: String?) {
//        self.title = title
//        self.category = category
//        self.memo = memo
//    }
//    static func == (lhs: Memo, rhs: Memo) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uuid)
//    }
//}

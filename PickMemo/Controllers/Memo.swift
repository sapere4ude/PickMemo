//
//  Memo.swift
//  PickMemo
//
//  Created by kant on 2022/12/19.
//

class Memo: Codable {
    var title: String?
    var memo: String?
    var category: String?
    
    init(title: String?,
         memo: String?,
         category: String?) {
        self.title = title
        self.category = category
        self.memo = memo
    }
}

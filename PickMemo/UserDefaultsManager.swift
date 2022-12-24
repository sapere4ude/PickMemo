//
//  UserDefaultsManager.swift
//  PickMemo
//
//  Created by kant on 2022/12/20.
//

import Foundation

class UserDefaultsManager {
    
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()

    // 메모 저장
    func setMemoList(with newValue: [Memo]){
        print("UserDefaultsManager - setMemoList() called / newValue: \(newValue.count)")
        do {
            let data = try PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "MemoList")
            UserDefaults.standard.synchronize()
            print("UserDefaultsManager - setMemoList() 메모가 저장됨")
        } catch {
            print("에러발생 setMemoList - error: \(error)")
        }
    }
    
    // 메모 저장 값 불러오기
    func getMemoList() -> [Memo]? {
        print("UserDefaultsManager - getMemoList() called")
        if let data = UserDefaults.standard.object(forKey: "MemoList") as? NSData {
            print("저장된 data: \(data.description)")
            do {
                let memoList = try PropertyListDecoder().decode([Memo].self, from: data as Data)
                return memoList
            } catch {
                print("에러발생 getMemoList - error: \(error)")
            }
        }
        return nil
    }    
}

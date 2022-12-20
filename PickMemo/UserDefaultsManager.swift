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
    
    //MARK: - 메모 관련
    
    /// 메모 목록 추가 및 저장하기
    /// - Parameter newValue: 저장할 값
    func setMemoList(with newValue: [Memo]){
        print("UserDefaultsManager - setMemoList() called / newValue: \(newValue.count)")
        do {
            let data = try PropertyListEncoder().encode(newValue)
            //newValue.forEach{ print("저장될 데이터: \($0.)") }
            UserDefaults.standard.set(data, forKey: "MemoList")
            UserDefaults.standard.synchronize()
            print("UserDefaultsManager - setMemoList() 메모가 저장됨")
        } catch {
            print("에러발생 setMemoList - error: \(error)")
        }
    }
    
    /// 저장된 메모 목록 가져오기
    /// - Returns: 저장된 값
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

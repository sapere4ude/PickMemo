//
//  SearchManager.swift
//  PickMemo
//
//  Created by Kant on 2023/04/25.
//

import Foundation
import Combine

class SearchManager {
    
//https://openapi.naver.com/v1/search/local.xml?query=%EB%8F%99%EB%8C%80%EB%AC%B8%EC%97%BD%EA%B8%B0%EB%96%A1%EB%B3%B6%EC%9D%B4%0D%0A&display=10&start=1&sort=random
    
    let baseURL = "https://openapi.naver.com/v1/search/local.xml?query="

    func requestGeocode(for query: String) -> AnyPublisher<String, Error> {
        let urlString = "\(baseURL)\(query)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // TODO: 여기 해결해보기
        //let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.addValue("zDiysQuQO8M5B_YCizZ8", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("DZJMGgyMEI", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

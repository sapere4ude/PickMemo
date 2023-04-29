//
//  SearchManager.swift
//  PickMemo
//
//  Created by Kant on 2023/04/25.
//

import Foundation
import Combine

class SearchManager {
    let baseURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode/?query="

    func requestGeocode(for query: String) -> AnyPublisher<String, Error> {
        let urlString = "\(baseURL)\(query)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // TODO: 여기 해결해보기
        //let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.addValue("b03tz3qpsf", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue("oTyWuVCsJwiHBCPg2hMYCEUjlBbpywwhOFs6RHiI", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
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

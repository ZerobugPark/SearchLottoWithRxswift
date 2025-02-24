//
//  NetworkManager.swift
//  SearchLottoWithRxswift
//
//  Created by youngkyun park on 2/24/25.
//

import Foundation

import RxSwift

enum APIError: Error {
    
    case urlInvalid
    case statusCodeError
    case unknownResponse
    case jsonError
    
    
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func callRequest<T: Decodable>(no: Int, type: T.Type) -> Observable<T> {
        
        return Observable<T>.create { value in
            let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(no)"
            
        //    print(urlString)
        
            
            guard let url = URL(string: urlString) else {
                value.onError(APIError.urlInvalid)
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    
                    if let status = response as? HTTPURLResponse {
                        print(status.statusCode)
                    }
                    value.onError(APIError.statusCodeError)
                    
                    return
                }
                
                if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        value.onNext(result)
                        value.onCompleted()
                    } catch {
                        value.onError(APIError.unknownResponse)
                    }
                } else {
                    value.onError(APIError.unknownResponse)
                }
                
                
            }.resume()
            
            return Disposables.create()
        }
    }
    
}

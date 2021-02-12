//
//  NetworkService.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

class NetworkService {

    func getRatesForTable(
        _ table: String,
        completion: @escaping(Result<APIResult, Error>) -> Void
    ) {
        let request = GetTable(table: table)
        makeRequest(request: request) { result in
            switch result {
            case .success(let apiResult):
                completion(.success(apiResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCurrencyDetails(
        table: String,
        code: String,
        startDate: String,
        endDate: String,
        completion: @escaping(Result<APIResult, Error>) -> Void
    ) {
        let request = GetCurrency(
            table: table,
            code: code,
            startDate: startDate,
            endDate: endDate)
        makeRequest(request: request) { result in
            switch result {
            case .success(let apiResult):
                completion(.success(apiResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func makeRequest(
        request: Request,
        completion: @escaping(Result<APIResult, Error>) -> Void
    ) {
        URLSession
            .shared
            .dataTask(with: request.urlRequest())
        { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            var result = APIResult()
            if let response = response as? HTTPURLResponse {
                result.responseCode = response.statusCode
            }
            if
                let data = data,
                let dataString = String(data: data, encoding: .utf8)
            {
                result.data = data
                result.responseString = dataString
                completion(.success(result))
            }
        }.resume()
    }
}

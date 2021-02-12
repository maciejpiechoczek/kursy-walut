//
//  Request.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class Request {

    var baseUrl: String {
        return "https://api.nbp.pl/api/exchangerates"
    }

    var path: String {
        return ""
    }
    
    var parameters: [String: Any?] {
        return [:]
    }
    
    var headers: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var method: RequestHTTPMethod {
        return body.isEmpty ? .get : .post
    }
    
    var body: [String: Any?] {
        return [:]
    }

    func urlRequest() -> URLRequest {
        var endpoint: String = baseUrl.appending(path)
        for parameter in parameters {
            if let value = parameter.value as? String {
                endpoint.append("?\(parameter.key)=\(value)")
            }
        }
        var request: URLRequest = URLRequest(url: URL(string: endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
        request.httpMethod = method.rawValue

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        if method == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("Request body parse error: \(error.localizedDescription)")
            }
        }

        return request
    }
}

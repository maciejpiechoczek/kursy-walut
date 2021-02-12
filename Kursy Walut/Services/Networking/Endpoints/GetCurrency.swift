//
//  GetCurrency.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 09/02/2021.
//

import Foundation

class GetCurrency: Request {
    
    private let table: String
    private let code: String
    private let startDate: String
    private let endDate: String

    init(table: String, code: String, startDate: String, endDate: String) {
        self.table = table
        self.code = code
        self.startDate = startDate
        self.endDate = endDate
    }

    override var path: String {
        return "/rates/\(table)/\(code)/\(startDate)/\(endDate)"
    }
}

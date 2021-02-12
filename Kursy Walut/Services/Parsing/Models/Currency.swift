//
//  Currency.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 09/02/2021.
//

import Foundation

struct Currency: Codable {
    let table: String
    let currency: String
    let code: String
    let rates: [CurrencyRate]
}

struct CurrencyRate: Codable {
    let no: String
    let effectiveDate: String
    let mid: Float?
    let bid: Float?
    let ask: Float?
}

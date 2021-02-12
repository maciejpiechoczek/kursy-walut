//
//  Table.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

struct Table: Codable {
    let table: String
    let no: String
    let effectiveDate: String
    let rates: [Rate]
}

struct Rate: Codable {
    let currency: String
    let code: String
    let mid: Float?
    let bid: Float?
    let ask: Float?
}

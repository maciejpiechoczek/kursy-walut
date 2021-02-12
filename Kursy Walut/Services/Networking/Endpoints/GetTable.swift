//
//  GetTable.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

class GetTable: Request {
    
    private let table: String

    init(table: String) {
        self.table = table
    }

    override var path: String {
        return "/tables/\(table)"
    }
}

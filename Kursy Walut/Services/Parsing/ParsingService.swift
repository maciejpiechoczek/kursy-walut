//
//  ParsingService.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

struct ParsingService {
    
    func parseTable(from data: Data) -> Table? {
        var table: Table?
        do {
            let tables = try JSONDecoder().decode([Table].self, from: data)
            table = tables.first
        } catch {
            print("Error took place: \(error.localizedDescription).")
        }
        return table
    }

    func parseCurrency(from data: Data) -> Currency? {
        var currency: Currency?
        do {
            currency = try JSONDecoder().decode(Currency.self, from: data)
        } catch {
            print("Error took place: \(error.localizedDescription).")
        }
        return currency
    }
}

//
//  StringValues.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 11/02/2021.
//

import Foundation

enum StringValues: String {
    case dateFormat = "yyyy-MM-dd"
    case empty = ""
    case valueSeparator = " / "
    case exchangeRates = "Kursy walut"
    case selectedTable = "Wybrana tabela: "
    case startDate = "Data początkowa"
    case endDate = "Data końcowa"
    case cancel = "Anuluj"
    case done = "OK"
    case refresh = "Odśwież"
    case noTableRecievedMessage = "Brak danych\nSpróbuj odświeżyć"
    case noCurrencyRecievedMessage = "Brak danych\nSpróbuj zmienić wybrane daty"
}

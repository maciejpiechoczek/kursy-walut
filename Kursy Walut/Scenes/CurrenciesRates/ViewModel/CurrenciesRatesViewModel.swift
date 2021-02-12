//
//  CurrenciesRatesViewModel.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import Foundation

protocol CurrenciesRatesViewModelDelegate: class {
    func tableDidChange()
}

class CurrenciesRatesViewModel {

    weak var delegate: CurrenciesRatesViewModelDelegate?

    private let networkService = NetworkService()
    private let parsingService = ParsingService()

    let tableTypes: [String] = ["A", "B", "C"]
    var table: Table? {
        didSet {
            delegate?.tableDidChange()
        }
    }

    private var currentTableIndex = 0

    func fetchTable( for index: Int? = nil) {
        let tableType = tableTypes[index ?? currentTableIndex]
        currentTableIndex = index ?? currentTableIndex
        
        networkService.getRatesForTable(tableType) { [weak self] result in
            Thread.sleep(forTimeInterval: 1) // Co prawda można to zasymulować za pomocą "Network Link Conditionera", ale postanowiłem ułatwić Wam zadanie 😊
            switch result {
            case .success(let apiResult):
                self?.parseTable(from: apiResult)
            case .failure(_):
                self?.table = nil
            }
        }
    }

    private func parseTable(from apiResult: APIResult) {
        guard let data = apiResult.data else {
            self.table = nil
            return
        }
        
        if let table = parsingService.parseTable(from: data) {
            self.table = table
        } else {
            self.table = nil
        }
    }
}

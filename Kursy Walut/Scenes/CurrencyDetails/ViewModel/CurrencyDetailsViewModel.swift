//
//  CurrencyDetailsViewModel.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 09/02/2021.
//

import Foundation

protocol CurrencyDetailsViewModelDelegate: class {
    func currencyDidChange()
}

class CurrencyDetailsViewModel {

    weak var delegate: CurrencyDetailsViewModelDelegate?

    private let networkService = NetworkService()
    private let parsingService = ParsingService()

    var currency: Currency? {
        didSet {
            delegate?.currencyDidChange()
        }
    }

    private var startDate: String
    private var endDate: String

    private let currentDate = Date()

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringValues.dateFormat.rawValue
        
        return dateFormatter
    }()

    init() {
        startDate = dateFormatter.string(from: currentDate)
        endDate = dateFormatter.string(from: currentDate)
    }

    func fetchDetails(startDate: String?, endDate: String?) {
        guard let currency = currency else { return }
        
        if let startDate = startDate {
            self.startDate = startDate
        }
        if let endDate = endDate {
            self.endDate = endDate
        }
        
        networkService.getCurrencyDetails(
            table: currency.table,
            code: currency.code,
            startDate: self.startDate,
            endDate: self.endDate
        ) { [weak self] result in
            Thread.sleep(forTimeInterval: 1) // Co prawda można to zasymulować za pomocą "Network Link Conditionera", ale postanowiłem ułatwić Wam zadanie 😊
            switch result {
            case .success(let apiResult):
                self?.parseCurrency(from: apiResult)
            case .failure(_):
                self?.currency = nil
            }
        }
    }

    private func parseCurrency(from apiResult: APIResult) {
        guard let data = apiResult.data else {
            currency = nil
            return
        }
        
        if let currency = parsingService.parseCurrency(from: data) {
            self.currency = currency
        } else {
            self.currency = nil
        }
    }
}

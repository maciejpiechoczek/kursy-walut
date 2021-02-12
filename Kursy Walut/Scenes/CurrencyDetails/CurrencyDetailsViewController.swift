//
//  CurrencyDetailsViewController.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 09/02/2021.
//

import UIKit

class CurrencyDetailsViewController: UIViewController {

    private let rootView = CurrencyDetailsView()
    private let viewModel = CurrencyDetailsViewModel()

    init(currency: Currency) {
        super.init(nibName: nil, bundle: nil)
        title = currency.code
        viewModel.delegate = self
        viewModel.currency = currency
        rootView.delegate = self
        rootView.currencyRatesDelegate = self
        rootView.currencyRatesDataSource = self
        rootView.setCurrencyName(name: currency.currency)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = rootView
        super.viewDidLoad()
    }

    func fetchCurrencyDetails(startDate: String, endDate: String) {
        viewModel.fetchDetails(startDate: startDate, endDate: endDate)
    }
}

extension CurrencyDetailsViewController: CurrencyDetailsViewModelDelegate {
    func currencyDidChange() {
        DispatchQueue.main.async {
            self.rootView.reloadData()
        }
    }
}

extension CurrencyDetailsViewController: CurrencyDetailsViewDelegate {
    func fetchCurrency(startDate: String?, endDate: String?) {
        viewModel.fetchDetails(startDate: startDate, endDate: endDate)
    }
}

extension CurrencyDetailsViewController:
    UITableViewDataSource,
    UITableViewDelegate
{
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let currency = viewModel.currency else { return 1 }
        
        return currency.rates.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyRatesListCell.description(),
                for: indexPath) as? CurrencyRatesListCell
        else {
            return UITableViewCell()
        }

        if let currency = viewModel.currency {
            cell.dateLabel.text = currency.rates[indexPath.row].effectiveDate
            
            if let mid = currency.rates[indexPath.row].mid {
                cell.valueLabel.text = String(mid)
            } else if
                let bid = currency.rates[indexPath.row].bid,
                let ask = currency.rates[indexPath.row].ask
            {
                let value = String(bid)
                    .appending(StringValues.valueSeparator.rawValue)
                    .appending(String(ask))
                cell.valueLabel.text = value
            }
        } else {
            cell.valueLabel.text = StringValues
                .noCurrencyRecievedMessage.rawValue
            cell.dateLabel.text = StringValues.empty.rawValue
        }

        return cell
    }
}

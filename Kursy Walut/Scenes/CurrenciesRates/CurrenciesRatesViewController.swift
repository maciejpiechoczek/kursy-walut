//
//  ViewController.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import UIKit

class CurrenciesRatesViewController: UIViewController {

    private let rootView = CurrenciesRatesView()
    private let viewModel = CurrenciesRatesViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
        rootView.delegate = self
        viewModel.delegate = self
        rootView.tablePickerDataSource = self
        rootView.tablePickerDelegate = self
        rootView.currencyListDelegate = self
        rootView.currencyListDataSource = self
        title = StringValues.exchangeRates.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = rootView
        super.viewDidLoad()
    }

    func fetchData(index: Int? = nil) {
        viewModel.fetchTable(for: index)
    }

    private func presentCurrencyDetails(for index: Int) {
        guard let table = viewModel.table else { return }
        
        let currencyRate = CurrencyRate(
            no: StringValues.empty.rawValue,
            effectiveDate: table.effectiveDate,
            mid: table.rates[index].mid,
            bid: table.rates[index].bid,
            ask: table.rates[index].ask)
        let currency = Currency(
            table: table.table,
            currency: table.rates[index].currency,
            code: table.rates[index].code,
            rates: [currencyRate])
        let viewController = CurrencyDetailsViewController(currency: currency)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CurrenciesRatesViewController: CurrenciesRatesViewDelegate {
    func fetchTable(index: Int?) {
        fetchData(index: index)
    }
}

extension CurrenciesRatesViewController: CurrenciesRatesViewModelDelegate {
    func tableDidChange() {
        DispatchQueue.main.async {
            self.rootView.reloadData()
        }
    }
}

extension CurrenciesRatesViewController:
    UIPickerViewDataSource,
    UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return viewModel.tableTypes.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return viewModel.tableTypes[row]
    }
}

extension CurrenciesRatesViewController:
    UITableViewDataSource,
    UITableViewDelegate
{
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 100
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let table = viewModel.table else { return 1 }
        
        return table.rates.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyListCell.description(),
                for: indexPath) as? CurrencyListCell
        else {
            return UITableViewCell()
        }

        if let table = viewModel.table {
            cell.dateLabel.text = table.effectiveDate
            if let mid = table.rates[indexPath.row].mid {
                cell.valueLabel.text = String(mid)
            } else if
                let bid = table.rates[indexPath.row].bid,
                let ask = table.rates[indexPath.row].ask
            {
                let value = String(bid)
                    .appending(StringValues.valueSeparator.rawValue)
                    .appending(String(ask))
                cell.valueLabel.text = value
            }
            cell.nameLabel.text = table.rates[indexPath.row].currency
            cell.codeLabel.text = table.rates[indexPath.row].code
        } else {
            cell.nameLabel.text = StringValues
                .noTableRecievedMessage.rawValue
            cell.dateLabel.text = StringValues.empty.rawValue
            cell.valueLabel.text = StringValues.empty.rawValue
        }
        
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presentCurrencyDetails(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

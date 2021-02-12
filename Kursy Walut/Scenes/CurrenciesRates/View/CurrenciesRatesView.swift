//
//  CurrenciesRatesView.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import UIKit

protocol CurrenciesRatesViewDelegate: class {
    func fetchTable(index: Int?)
}

class CurrenciesRatesView: UIView {

    weak var delegate: CurrenciesRatesViewDelegate?

    weak var tablePickerDelegate: UIPickerViewDelegate? {
        didSet {
            tablePicker.delegate = tablePickerDelegate
        }
    }

    weak var tablePickerDataSource: UIPickerViewDataSource? {
        didSet {
            tablePicker.dataSource = tablePickerDataSource
        }
    }

    weak var currencyListDelegate: UITableViewDelegate? {
        didSet {
            currencyList.delegate = currencyListDelegate
        }
    }

    weak var currencyListDataSource: UITableViewDataSource? {
        didSet {
            currencyList.dataSource = currencyListDataSource
        }
    }

    private let tableLabel: UILabel = {
        let view = UILabel()
        view.text = StringValues.selectedTable.rawValue
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .black
        view.sizeToFit()
        
        return view
    }()

    private let tablePicker = UIPickerView()
    private let tableTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .none
        view.tintColor = .clear
        view.text = "A"
        view.backgroundColor = .white
        view.textColor = .systemBlue
        
        let toolbar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 35))
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let done = UIBarButtonItem(
            title: StringValues.done.rawValue,
            style: .plain,
            target: self,
            action: #selector(didTapDone))
        toolbar.setItems([space, done], animated: false)
        toolbar.sizeToFit()
        view.inputAccessoryView = toolbar
        
        return view
    }()

    private let currencyList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.register(
            CurrencyListCell.self,
            forCellReuseIdentifier: CurrencyListCell.description())
        
        return tableView
    }()

    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(StringValues.refresh.rawValue, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        
        return button
    }()

    init() {
        super.init(frame: .zero)
        tableTextField.inputView = tablePicker
        backgroundColor = .white
        currencyList.refreshControl = UIRefreshControl()
        currencyList.refreshControl?.addTarget(
            self,
            action: #selector(refreshCurrencies),
            for: .valueChanged)
        currencyList.refreshControl?.tintColor = .black
        refreshButton.addTarget(
            self,
            action: #selector(refreshCurrencies),
            for: .touchUpInside)
        currencyList.refreshControl?.beginRefreshing()
        constructHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        currencyList.reloadData()
        currencyList.refreshControl?.endRefreshing()
    }

    @objc private func refreshCurrencies() {
        beginRefreshingList()
        delegate?.fetchTable(index: nil)
    }

    @objc private func didTapDone() {
        let selectedIndex = tablePicker.selectedRow(inComponent: 0)
        if
            let tableName = tablePicker.delegate?.pickerView?(
            tablePicker,
            titleForRow: selectedIndex,
            forComponent: 0)
        {
            tableTextField.text = tableName
        }
        beginRefreshingList()
        delegate?.fetchTable(index: selectedIndex)
        tableTextField.resignFirstResponder()
    }

    private func beginRefreshingList() {
        if let refreshControll = currencyList.refreshControl {
            let offset = CGPoint(x: 0, y: -refreshControll.frame.height)
            refreshControll.beginRefreshing()
            currencyList.setContentOffset(offset, animated: true)
        }
    }

    private func constructHierarchy() {
        addSubview(tableLabel)
        addSubview(tableTextField)
        addSubview(currencyList)
        addSubview(refreshButton)
    }

    private func activateConstraints() {
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableLabel.topAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.topAnchor,
                    constant: 10),
            tableLabel.leadingAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.leadingAnchor,
                    constant: 75)
        ])

        tableTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableTextField.centerYAnchor
                .constraint(equalTo: tableLabel.centerYAnchor),
            tableTextField.leadingAnchor
                .constraint(equalTo: tableLabel.trailingAnchor, constant: 15),
            tableTextField.widthAnchor
                .constraint(equalToConstant: 30)
        ])

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.centerYAnchor
                .constraint(equalTo: tableLabel.centerYAnchor),
            refreshButton.trailingAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.trailingAnchor,
                    constant: -25),
            refreshButton.heightAnchor
                .constraint(equalToConstant: 28)
        ])

        currencyList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyList.leadingAnchor
                .constraint(equalTo: compatibleLayoutGuide.leadingAnchor),
            currencyList.trailingAnchor
                .constraint(equalTo: compatibleLayoutGuide.trailingAnchor),
            currencyList.bottomAnchor
                .constraint(equalTo: compatibleLayoutGuide.bottomAnchor),
            currencyList.topAnchor
                .constraint(equalTo: tableTextField.bottomAnchor, constant: 15)
        ])
    }
}

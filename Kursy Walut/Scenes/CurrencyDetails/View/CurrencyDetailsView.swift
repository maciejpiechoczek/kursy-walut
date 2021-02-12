//
//  CurrencyDetailsView.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 09/02/2021.
//

import UIKit

protocol CurrencyDetailsViewDelegate: class {
    func fetchCurrency(startDate: String?, endDate: String?)
}

class CurrencyDetailsView: UIView {

    weak var delegate: CurrencyDetailsViewDelegate?

    weak var currencyRatesDelegate: UITableViewDelegate? {
        didSet {
            ratesList.delegate = currencyRatesDelegate
        }
    }

    weak var currencyRatesDataSource: UITableViewDataSource? {
        didSet {
            ratesList.dataSource = currencyRatesDataSource
        }
    }

    private let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -367, to: Date())
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()

    private let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()

    let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        return label
    }()

    let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = StringValues.startDate.rawValue
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        
        return label
    }()

    let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = StringValues.endDate.rawValue
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        
        return label
    }()

    let startDateTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .none
        view.tintColor = .clear
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

    let endDateTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .none
        view.tintColor = .clear
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

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringValues.dateFormat.rawValue
        
        return dateFormatter
    }()

    private let ratesList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.register(
            CurrencyRatesListCell.self,
            forCellReuseIdentifier: CurrencyRatesListCell.description())
        
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
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        
        if let picker = endDateTextField.inputView as? UIDatePicker {
            picker.minimumDate = Date()
        }
        backgroundColor = .white
        
        ratesList.refreshControl = UIRefreshControl()
        ratesList.refreshControl?.addTarget(
            self,
            action: #selector(refreshRates),
            for: .valueChanged)
        ratesList.refreshControl?.tintColor = .black
        
        refreshButton.addTarget(
            self,
            action: #selector(refreshRates),
            for: .touchUpInside)
        let date = Date()
        
        startDateTextField.text = dateFormatter.string(from: date)
        endDateTextField.text = dateFormatter.string(from: date)
        
        constructHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCurrencyName(name: String) {
        currencyNameLabel.text = name
    }

    func reloadData() {
        ratesList.reloadData()
        ratesList.refreshControl?.endRefreshing()
    }

    @objc private func refreshRates() {
        beginRefreshingList()
        delegate?.fetchCurrency(startDate: nil, endDate: nil)
    }

    @objc private func didTapCancel() {
        if startDateTextField.isFirstResponder {
            startDateTextField.resignFirstResponder()
        } else if endDateTextField.isFirstResponder {
            endDateTextField.resignFirstResponder()
        }
    }

    @objc private func didTapDone() {
        if startDateTextField.isFirstResponder {
            let startDate = dateFormatter.string(from: startDatePicker.date)
            startDateTextField.text = startDate
            
            delegate?.fetchCurrency(startDate: startDate, endDate: nil)
            if let picker = endDateTextField.inputView as? UIDatePicker {
                picker.minimumDate = startDatePicker.date
            }
            startDateTextField.resignFirstResponder()
            
        } else if endDateTextField.isFirstResponder {
            let endDate = dateFormatter.string(from: endDatePicker.date)
            endDateTextField.text = endDate
            
            delegate?.fetchCurrency(startDate: nil, endDate: endDate)
            if let picker = startDateTextField.inputView as? UIDatePicker {
                picker.maximumDate = endDatePicker.date
            }
            endDateTextField.resignFirstResponder()
        }
        beginRefreshingList()
    }

    private func beginRefreshingList() {
        if let refreshControll = ratesList.refreshControl {
            let offset = CGPoint(x: 0, y: -refreshControll.frame.height)
            refreshControll.beginRefreshing()
            ratesList.setContentOffset(offset, animated: true)
        }
    }

    private func constructHierarchy() {
        addSubview(currencyNameLabel)
        addSubview(startDateLabel)
        addSubview(endDateLabel)
        addSubview(startDateTextField)
        addSubview(endDateTextField)
        addSubview(refreshButton)
        addSubview(ratesList)
    }

    private func activateConstraints() {
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyNameLabel.topAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.topAnchor,
                    constant: 10),
            currencyNameLabel.centerXAnchor
                .constraint(equalTo: compatibleLayoutGuide.centerXAnchor)
        ])

        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDateLabel.leadingAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.leadingAnchor,
                    constant: 12),
            startDateLabel.topAnchor
                .constraint(
                    equalTo: currencyNameLabel.bottomAnchor,
                    constant: 20)
        ])

        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDateLabel.leadingAnchor
                .constraint(equalTo: startDateLabel.leadingAnchor),
            endDateLabel.topAnchor
                .constraint(
                    equalTo: startDateLabel.bottomAnchor,
                    constant: 8)
        ])

        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDateTextField.leadingAnchor
                .constraint(
                    equalTo: startDateLabel.trailingAnchor,
                    constant: 12),
            startDateTextField.centerYAnchor
                .constraint(equalTo: startDateLabel.centerYAnchor)
        ])

        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDateTextField.leadingAnchor
                .constraint(
                    equalTo: endDateLabel.trailingAnchor,
                    constant: 12),
            endDateTextField.centerYAnchor
                .constraint(equalTo: endDateLabel.centerYAnchor)
        ])

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.centerYAnchor
                .constraint(
                    equalTo: startDateLabel.bottomAnchor, constant: 4),
            refreshButton.trailingAnchor
                .constraint(
                    equalTo: compatibleLayoutGuide.trailingAnchor,
                    constant: -25),
            refreshButton.heightAnchor
                .constraint(equalToConstant: 28)
        ])

        ratesList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratesList.leadingAnchor
                .constraint(equalTo: compatibleLayoutGuide.leadingAnchor),
            ratesList.trailingAnchor
                .constraint(equalTo: compatibleLayoutGuide.trailingAnchor),
            ratesList.bottomAnchor
                .constraint(equalTo: compatibleLayoutGuide.bottomAnchor),
            ratesList.topAnchor
                .constraint(
                    equalTo: endDateTextField.bottomAnchor,
                    constant: 15)
        ])
    }
}

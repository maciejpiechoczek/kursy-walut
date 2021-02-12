//
//  CurrencyRatesListCell.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 10/02/2021.
//

import UIKit

class CurrencyRatesListCell: UITableViewCell {

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        
        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func constructHierarchy() {
        contentView.addSubview(valueLabel)
        contentView.addSubview(dateLabel)
    }

    private func activateConstraints() {

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 12)
        ])

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

//
//  CurrencyListCell.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 08/02/2021.
//

import UIKit

class CurrencyListCell: UITableViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .black
        
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        
        return label
    }()

    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(dateLabel)
    }

    private func activateConstraints() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor
                .constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 12)
        ])

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.topAnchor
                .constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor
                .constraint(equalTo: nameLabel.leadingAnchor)
        ])

        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeLabel.topAnchor
                .constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            codeLabel.leadingAnchor
                .constraint(equalTo: nameLabel.leadingAnchor)
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

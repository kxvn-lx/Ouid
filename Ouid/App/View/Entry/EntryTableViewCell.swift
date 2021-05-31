//
//  EntryTableViewCell.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    static let REUSE_IDENTIFIER = "EntryTableViewCell"
    var entry: Entry! {
        didSet {
            dateView.date = entry.date
            amountLabel.attributedText = NSMutableAttributedString()
                .bold(String(entry.measurement.value) + " ")
                .normal(entry.measurement.unit.symbol.uppercased())
            timeLabel.text = parseTime(from: entry.date)
        }
    }
    
    private let dateView = DateView()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .rounded(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    private var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraint()
    
        backgroundColor = .secondarySystemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupView() {
        stackView = UIStackView(arrangedSubviews: [dateView, amountLabel, timeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        
        addSubview(stackView)
    }
    
    private func setupConstraint() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
        
        dateView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
    
    private func parseTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        return formatter.string(from: date)
    }
}

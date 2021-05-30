//
//  DateView.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import UIKit

class DateView: UIView {
    var date: Date! {
        didSet {
            monthLabel.text = parseMonth(from: date).uppercased()
            dateLabel.text = parseDate(from: date)
        }
    }
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraint()

        layer.cornerRadius = 12.5
        layer.masksToBounds = true
        
        backgroundColor = .secondarySystemGroupedBackground
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView = UIStackView(arrangedSubviews: [monthLabel, dateLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        addSubview(stackView)
    }
    
    private func setupConstraint() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func parseMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return formatter.string(from: date)
    }
    
    private func parseDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        return formatter.string(from: date)
    }
}

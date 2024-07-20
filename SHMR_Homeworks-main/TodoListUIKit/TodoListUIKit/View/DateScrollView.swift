//
//  DateScrollView.swift
//  TodoListUIKit
//
//  Created by Liubov Smirnova on 06.07.2024.
//

import UIKit

class DateScrollView: UIView {

    var dates: [Date] = []
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        updateDates() // Initial setup
    }

    private func updateDates() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        for date in dates {
            let dateButton = UIButton(type: .system)
            dateButton.setTitle(dateFormatter.string(from: date), for: .normal)
            dateButton.addTarget(self, action: #selector(dateTapped(_:)), for: .touchUpInside)
            dateButton.layer.cornerRadius = 8
            dateButton.backgroundColor = .lightGray
            dateButton.setTitleColor(.white, for: .normal)
            dateButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            stackView.addArrangedSubview(dateButton)
        }

        // Add "Другое" button
        let otherButton = UIButton(type: .system)
        otherButton.setTitle("Другое", for: .normal)
        otherButton.addTarget(self, action: #selector(otherTapped(_:)), for: .touchUpInside)
        otherButton.layer.cornerRadius = 8
        otherButton.backgroundColor = .lightGray
        otherButton.setTitleColor(.white, for: .normal)
        otherButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.addArrangedSubview(otherButton)
    }

    func setDates(_ newDates: [Date]) {
        dates = newDates
        updateDates()
    }

    @objc private func dateTapped(_ sender: UIButton) {
        if let dateString = sender.title(for: .normal), let date = dates.first(where: { DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .none) == dateString }) {
            NotificationCenter.default.post(name: .didSelectDate, object: date)
        }
    }

    @objc private func otherTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didSelectDate, object: nil)
    }
}
